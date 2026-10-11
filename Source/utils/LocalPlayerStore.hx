package utils;

#if sys
import sys.FileSystem;
import sys.io.File;
#end
import haxe.Json;
import lime.system.System;

/**
	Local stand-in for the account endpoints the game used to call, as a folder of save files.

	`BambaLoader` posted to `playerDataSource`, `newPlayerDataSource`, `updatePlayerDataSource`
	and `forgetPassSource` (see Assets/xmls/params.xml) and parsed an XML reply carrying an
	`errorCode`. With the server gone, signing up went nowhere: `sendNewPlayerData` fired a
	`URLLoader` at a dead host, `Event.COMPLETE` never arrived, and the player sat behind the
	"creating a new user" wait box forever.

	Each character is now one file - `<user>.bmksave` under `savesDirectory()` - so a save can
	be picked from a native Open dialog, copied, renamed, backed up or hand-edited. Logging in
	means choosing a file rather than typing a name and password; `currentPath` remembers which
	file the session is playing, and every later save overwrites it.

	The format is pretty-printed JSON rather than the `haxe.Serializer` output a `SharedObject`
	would write, because these files are meant to be opened and read by a person. Id lists are
	real JSON arrays, but every element is coerced back to Int on the way in: `Json.parse` is
	free to hand back a Float, and a Float that has drifted - or a String from a hand edit -
	would silently fail every `id == ...` comparison in the catalogs.

	Desktop only. All file access is behind `#if sys`, so other targets still compile but report
	that saving is unavailable rather than half-working; html5 would need a localStorage-backed
	variant.
**/
class LocalPlayerStore {
	public static inline var SAVE_EXTENSION = ".bmksave";

	/**
		Deliberately no filter for `lime.ui.FileDialog.browse()`.

		lime documents the filter as a wildcard pattern ("*.jpg"), and that is what Windows and
		GTK want, but on macOS the dialog is an AppleScript `choose file ... of type {...}`, and
		`of type` matches name extensions and UTIs - never patterns. lime passes the pattern
		through verbatim, so "*.bmksave" is not a form macOS understands and every file would be
		greyed out: to the player, their saves would simply have vanished.

		`defaultPath` already opens the dialog in the saves folder, where these are the only
		files, and `loadFile()` refuses anything that is not a save with a message. That is a
		better trade than a filter that silently hides everything on one platform.
	**/
	public static inline var SAVE_FILTER:String = null;

	static inline var FORMAT_VERSION = 1;

	// The error codes the original server returned, kept so the callers' switch statements and
	// dictionary messages stay exactly as they were.
	public static inline var OK = 0;

	/** Sign-up: a save file of that name already exists. **/
	public static inline var ERR_NAME_TAKEN = 1;

	/**
		Sign-up: the mail address is malformed. `createAccount` never returns this - the client
		validates the address itself in `BambaNewPlayerScreen.checkEnter()` before getting here -
		but the code is part of the contract the caller still switches on.
	**/
	public static inline var ERR_ILLEGAL_MAIL = 2;

	/** Sign-up: the mail address is already used by another save. **/
	public static inline var ERR_MAIL_TAKEN = 3;

	/** Forgotten password: the mail address matches no save here. **/
	public static inline var ERR_MAIL_UNKNOWN = 1;

	/** Could not read or write the file at all. **/
	public static inline var ERR_IO = 4;

	/**
		The save file this session is playing - set by `createAccount()` or a successful
		`loadFile()`, and the target of every `saveFrom()`. Null before either has happened.
	**/
	public static var currentPath(default, null):String = null;

	public static function savesDirectory():String {
		#if sys
		// applicationStorageDirectory ends with a separator - "\\" on Windows - so strip either
		// kind before appending. Windows' Open dialog rejects a mixed "...\/saves" path outright:
		// lime's browse() then reports a cancel without ever showing the dialog.
		var base = System.applicationStorageDirectory;
		while (StringTools.endsWith(base, "/") || StringTools.endsWith(base, "\\")) base = base.substr(0, base.length - 1);
		#if windows
		var dir = StringTools.replace(base, "/", "\\") + "\\saves";
		#else
		var dir = base + "/saves";
		#end
		try {
			if (!FileSystem.exists(dir)) FileSystem.createDirectory(dir);
		} catch (e:Dynamic) {
			trace("LocalPlayerStore: could not create " + dir + " (" + e + ")");
		}
		return dir;
		#else
		return null;
		#end
	}

	public static function listSaves():Array<String> {
		var found:Array<String> = [];
		#if sys
		var dir = savesDirectory();
		try {
			if (dir != null && FileSystem.exists(dir)) {
				for (name in FileSystem.readDirectory(dir)) {
					if (StringTools.endsWith(name.toLowerCase(), SAVE_EXTENSION)) found.push(dir + "/" + name);
				}
			}
		} catch (e:Dynamic) {
			trace("LocalPlayerStore: could not list " + dir + " (" + e + ")");
		}
		#end
		return found;
	}

	/**
		The most recently saved file, or null if there are none.

		Targets with no native Open dialog (consoles, lime-nx included) can't let the player
		browse to a save, so `BambaLoader.loadPlayerData()` falls back to continuing whichever
		save was played last instead.
	**/
	public static function mostRecentSave():String {
		var best:String = null;
		#if sys
		var bestTime = -1.0;
		for (path in listSaves()) {
			try {
				var mtime = FileSystem.stat(path).mtime.getTime();
				if (mtime > bestTime) {
					bestTime = mtime;
					best = path;
				}
			} catch (e:Dynamic) {
				trace("LocalPlayerStore: could not stat " + path + " (" + e + ")");
			}
		}
		#end
		return best;
	}

	/**
		Turns a player name into a file name. Hebrew is fine - these are UTF-8 paths - but the
		path separators and the handful of characters that are awkward across filesystems are
		not, and a name that reduces to nothing still needs somewhere to go.
	**/
	static function fileNameFor(user:String):String {
		var safe = user == null ? "" : StringTools.trim(user);
		for (bad in ["/", "\\", ":", "*", "?", "\"", "<", ">", "|"]) {
			safe = StringTools.replace(safe, bad, "_");
		}
		if (safe == "" || safe == "." || safe == "..") safe = "player";
		return safe + SAVE_EXTENSION;
	}

	// ---- reading and writing ------------------------------------------------------------

	/** For a save picker: `pName`, `level`, `saved` (string) + `path`, or null if unreadable. **/
	public static function describeSave(path:String):Dynamic {
		var rec = readRecord(path);
		if (rec == null) return null;
		return {
			path: path,
			pName: rec.pName != null ? Std.string(rec.pName) : "",
			level: Std.int(num(rec.level, 1)),
			saved: rec.saved != null ? Std.string(rec.saved) : (rec.created != null ? Std.string(rec.created) : "")
		};
	}

	static function readRecord(path:String):Dynamic {
		#if sys
		try {
			if (path == null || !FileSystem.exists(path)) return null;
			return Json.parse(File.getContent(path));
		} catch (e:Dynamic) {
			trace("LocalPlayerStore: could not read " + path + " (" + e + ")");
			return null;
		}
		#else
		return null;
		#end
	}

	static function writeRecord(path:String, rec:Dynamic):Bool {
		#if sys
		try {
			File.saveContent(path, Json.stringify(rec, null, "  "));
			return true;
		} catch (e:Dynamic) {
			trace("LocalPlayerStore: could not write " + path + " (" + e + ")");
			return false;
		}
		#else
		trace("LocalPlayerStore: saving is not available on this target");
		return false;
		#end
	}

	/** Coerces a parsed JSON list into whole-number ids. **/
	static function ids(value:Dynamic):Array<Dynamic> {
		var result:Array<Dynamic> = [];
		if (value == null) return result;
		var raw:Array<Dynamic> = Std.isOfType(value, Array) ? cast value : cast Std.string(value).split(",");
		for (item in raw) {
			if (item == null) continue;
			var asFloat = Std.isOfType(item, String) ? Std.parseFloat(Std.string(item)) : (item : Float);
			if (Math.isNaN(asFloat)) continue;
			result.push(Std.int(asFloat));
		}
		return result;
	}

	static function num(value:Dynamic, fallback:Float):Float {
		if (value == null) return fallback;
		var asFloat = Std.isOfType(value, String) ? Std.parseFloat(Std.string(value)) : (value : Float);
		return Math.isNaN(asFloat) ? fallback : asFloat;
	}

	// ---- accounts -----------------------------------------------------------------------

	public static function mailOwner(mail:String):Dynamic {
		if (mail == null) return null;
		var wanted = StringTools.trim(mail).toLowerCase();
		if (wanted == "") return null;
		for (path in listSaves()) {
			var rec = readRecord(path);
			if (rec == null || rec.mail == null) continue;
			if (StringTools.trim(rec.mail).toLowerCase() == wanted) return rec;
		}
		return null;
	}

	/**
		Creates a new save file with no character yet: `pName` is left empty, which is the state
		a server-side sign-up left the game in, and what `BambaMain.startGame()` tests to decide
		whether to send the player to the character builder. The new file becomes `currentPath`,
		so the character the player then builds is saved into it.
	**/
	public static function createAccount(user:String, pass:String, mail:String, birthDate:String):Int {
		#if sys
		var dir = savesDirectory();
		if (dir == null) return ERR_IO;
		var path = dir + "/" + fileNameFor(user);
		if (FileSystem.exists(path)) return ERR_NAME_TAKEN;
		if (mailOwner(mail) != null) return ERR_MAIL_TAKEN;

		var rec = {
			format: FORMAT_VERSION,
			user: user,
			pass: pass,
			mail: mail,
			birthDate: birthDate,
			created: Date.now().toString(),
			saved: Date.now().toString(),
			pName: "",
			level: 1,
			orderCode: 0,
			exPoints: 0,
			money: 0,
			ingredients: [0, 0, 0, 0],
			magic: [],
			cards: [],
			items: [],
			itemsInUse: [0, 0, 0, 0, 0, 0, 0, 0],
			currentQuestId: 0,
			pastQuestsIds: [],
			pastDungeonsIds: []
		};
		if (!writeRecord(path, rec)) return ERR_IO;
		currentPath = path;
		trace("LocalPlayerStore: created " + path);
		return OK;
		#else
		return ERR_IO;
		#end
	}

	// ---- progress -----------------------------------------------------------------------

	/**
		Reads a save file into `playerData` and adopts it as `currentPath`. Every field is
		written, including the empty defaults of a file with no character, so nothing downstream
		can meet a null array.

		`setLevelDependingData()` is deliberately *not* called here: it reads the player-level
		and item catalogs, and a save can be opened before those have finished loading.
		`BambaMain.startGame()` already calls it once, behind its `finishLoading` check.
	**/
	public static function loadFile(path:String, playerData:BambaPlayerData):Bool {
		var rec = readRecord(path);
		if (rec == null) return false;

		playerData.setUserPass(rec.user != null ? rec.user : "", rec.pass != null ? rec.pass : "");
		playerData.pName = rec.pName != null ? rec.pName : "";
		playerData.level = num(rec.level, 1);
		playerData.orderCode = Std.int(num(rec.orderCode, 0));
		playerData.exPoints = num(rec.exPoints, 0);
		playerData.money = num(rec.money, 0);
		playerData.currentQuestId = num(rec.currentQuestId, 0);
		playerData.currentQuestDetails = null;
		var quest:Dynamic = rec.currentQuest;
		if (quest != null && quest.dungeonId != null && quest.difficulty != null) {
			playerData.currentQuestDetails = [
				num(quest.dungeonId, 0),
				num(quest.difficulty, 1),
				quest.enemyId == null ? Math.NaN : num(quest.enemyId, Math.NaN),
				num(quest.enemyType, 1)
			];
		}

		var ing = ids(rec.ingredients);
		playerData.ingredient1 = ing.length > 0 ? ing[0] : 0;
		playerData.ingredient2 = ing.length > 1 ? ing[1] : 0;
		playerData.ingredient3 = ing.length > 2 ? ing[2] : 0;
		playerData.ingredient4 = ing.length > 3 ? ing[3] : 0;

		playerData.magic = ids(rec.magic);
		// Declared Array<BambaCard> but holds card ids, as it does when resetPlayerData()
		// fills it straight from gameData.ordersStartDefs.
		playerData.cards = cast ids(rec.cards);
		playerData.items = ids(rec.items);
		playerData.pastQuestsIds = ids(rec.pastQuestsIds);
		playerData.pastDungeonsIds = ids(rec.pastDungeonsIds);

		var inUse = ids(rec.itemsInUse);
		// Eight equipment slots, always: the rest of the game indexes into this by item type.
		playerData.itemsInUse = [0, 0, 0, 0, 0, 0, 0, 0];
		for (i in 0...(inUse.length < 8 ? inUse.length : 8)) {
			playerData.itemsInUse[i] = inUse[i];
		}

		currentPath = path;
		trace("LocalPlayerStore: opened " + path + " pName='" + playerData.pName
			+ "' level=" + playerData.level + " order=" + playerData.orderCode);
		return true;
	}

	/**
		Writes `playerData` back to the file the session is playing - the same fields the old
		`updatePlayerDataSource` POST carried.
	**/
	public static function saveFrom(playerData:BambaPlayerData):Bool {
		if (currentPath == null) {
			trace("LocalPlayerStore: cannot save, no save file is open");
			return false;
		}
		// Keep whatever the file already held for fields the game does not own (mail, birth
		// date, when it was created), rather than dropping them on every save.
		var rec:Dynamic = readRecord(currentPath);
		if (rec == null) rec = {};

		rec.format = FORMAT_VERSION;
		rec.user = playerData.user;
		rec.pass = playerData.pass;
		rec.saved = Date.now().toString();
		rec.pName = playerData.pName;
		rec.level = playerData.level;
		rec.orderCode = playerData.orderCode;
		rec.exPoints = playerData.exPoints;
		rec.money = playerData.money;
		rec.ingredients = [playerData.ingredient1, playerData.ingredient2, playerData.ingredient3, playerData.ingredient4];
		rec.magic = playerData.magic.copy();
		rec.cards = (cast playerData.cards : Array<Dynamic>).copy();
		rec.items = playerData.items.copy();
		rec.itemsInUse = playerData.itemsInUse.copy();
		rec.currentQuestId = playerData.currentQuestId;
		// JSON has no NaN, so "no enemy" is stored as null.
		var details = playerData.currentQuestDetails;
		rec.currentQuest = (playerData.currentQuestId == 0 || details == null) ? null : {
			dungeonId: details[0],
			difficulty: details[1],
			enemyId: Math.isNaN(details[2]) ? null : details[2],
			enemyType: details[3]
		};
		rec.pastQuestsIds = playerData.pastQuestsIds.copy();
		rec.pastDungeonsIds = playerData.pastDungeonsIds.copy();

		var ok = writeRecord(currentPath, rec);
		if (ok) trace("LocalPlayerStore: saved " + currentPath + " level=" + rec.level);
		return ok;
	}
}
