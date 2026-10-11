package;

import haxe.ui.Toolkit;
import dungeon_graphics.DungeonMain;
import general_assets.GeneralFrame;
import haxe.Timer;
import erate.ERate;
import openfl.display.*;
import openfl.net.SharedObject;
import openfl.events.*;
import openfl.geom.Rectangle;
import general.ButtonUpdater;
import general.Heb;
import general.MsgBox;
import general.PlayerDataUpdater;

class BambaMain extends Sprite{
	// The authored stage size of the original Flash game (frames.swf / openingAssets.swf are
	// both 940x650); all the hardcoded screen coordinates in this project assume it.
	public static inline var DESIGN_WIDTH = 940;

	public static inline var DESIGN_HEIGHT = 650;

	var soundTimer: Timer = null;

	var characterBuildTimer: Timer = null;

	var currDungeonDifficulty:Float;

	public var gameMap:BambaMap;

	public var msgShown:Bool;

	public var gameAssets:BambaAssets;

	var currDongeonId:Float;

	var magicBook:BambaMagicBook;

	var currEnemyId:Float;

	public var didLogin:Bool;

	public var questManager:BambaQuestManager;
	

	var newPlayer:BambaNewPlayerScreen;

	public var gameLoader:BambaLoader;

	var eventTypeNames:Dynamic;

	public var gameData:BambaData;

	var characterBuild:BambaCharacterBuildScreen;

	public var ToolID:Dynamic;

	var store:BambaStore;

	public var autoLogin:Bool;

	public var  tower:BambaTower;

	public var aDungeon:BambaDungeon;

	public var sound:BambaSoundManager;


	var character:BambaCharacterScreen;

	public var movie:BambaMovie;

	public var finishLoading:Bool;

	public var help:BambaHelp;

	public var opening:BambaOpeningScreen;

	var menu:BambaMenuScreen;

	var  upgradeSystem:BambaUpgradeSystem;
	
	public var userSharedObject:SharedObject;

	var eventTypeCodes:Array<Int>;

	public var frameMC:GeneralFrame;

	var dungeonMC:DungeonMain;

	public function new() {
		super();
		Toolkit.init();
		eventTypeCodes = [1, 3, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28];
		eventTypeNames = [
			"hasifa",
			"lead",
			"enter game",
			"uniq",
			"new user enter",
			"new user game enter",
			"user game enter",
			"game enter",
			"movie",
			"new character",
			"exit",
			"start mission1",
			"start mission2",
			"start mission3",
			"start mission4",
			"end mission1",
			"end mission2",
			"end mission3",
			"end mission4",
			"help",
			"main"
		];
		getHTMLvars();
		checkUser();
		gameData = new BambaData(this);
		gameAssets = new BambaAssets(this);
		sound = new BambaSoundManager(this);
		movie = new BambaMovie(this);
		gameLoader = new BambaLoader(this);
		help = new BambaHelp(this);
		msgShown = false;
		finishLoading = false;
		didLogin = false;
		autoLogin = true;
		
		if (this.stage != null) {
			init();
		} else {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
	}

	function onAddedToStage(_):Void {
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		init();
	}

	private function init() {
		// Every screen is positioned against the original Flash stage (see centerScreen() /
		// cornerScreen()), so instead of re-laying anything out we scale this whole display
		// tree - game screens, the frame and the intro movie clip alike - to the window.
		// NO_SCALE keeps stageWidth/stageHeight equal to the real window so the maths below
		// is ours rather than fighting OpenFL's own display matrix.
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		// Clip the game to its authored stage. Screens slide in from off-stage and some art
		// overhangs the edges; in Flash the stage hid that, but here the letterbox bars
		// fitToStage leaves would show it. scrollRect is in local space, so it scales with us.
		this.scrollRect = new Rectangle(0, 0, DESIGN_WIDTH, DESIGN_HEIGHT);
		utils.DebugCapture.install(openfl.Lib.current.stage);
		utils.DisplaySettings.init();
		stage.addEventListener(Event.RESIZE, onStageResize);
		stage.addEventListener(KeyboardEvent.KEY_DOWN, onStageKeyDown);
		#if debug
		stage.addEventListener(MouseEvent.MOUSE_DOWN, traceClickTarget, true);
		// Measured frame rate, every 5 seconds.
		var frames = 0;
		var since = haxe.Timer.stamp();
		stage.addEventListener(Event.ENTER_FRAME, function(_) {
			frames++;
			var now = haxe.Timer.stamp();
			if (now - since >= 5) {
				trace("FPS " + Math.round(frames / (now - since)));
				frames = 0;
				since = now;
			}
		});
		// The capture listener above never sees a click that hits nothing (its target is the
		// stage itself), so log those too: they mean the screen under the mouse isn't clickable.
		stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent) {
			if (e.target == stage) trace("CLICK on empty stage at " + e.stageX + "," + e.stageY);
		});
		#end
		fitToStage();
		// Studio splash. Hides this sprite so BambaLoader's loading screen does not peek
		// around the splash's black bars on a non-16:9 window; the game keeps loading
		// underneath so by the time the splash fades the opening screen is already warm.
		utils.StudioIntro.play(stage, this, null);
	}

	#if debug
	// Diagnostic: logs which display object a click lands on, and its parent chain.
	function traceClickTarget(e:MouseEvent):Void {
		var chain = [];
		var o:DisplayObject = cast e.target;
		while (o != null && o != stage) {
			chain.push(Type.getClassName(Type.getClass(o)) + (o.name != null ? "(" + o.name + ")" : ""));
			o = o.parent;
		}
		trace("CLICK at " + e.stageX + "," + e.stageY + " msgShown=" + msgShown + " -> " + chain.join(" < "));
	}
	#end

	/**
		F11 toggles fullscreen. Desktop builds already start fullscreen (project.xml); in a
		browser this is the only way in, as fullscreen needs a user gesture there.
	**/
	function onStageKeyDown(e:KeyboardEvent):Void {
		if (e.keyCode != openfl.ui.Keyboard.F11) return;
		try {
			stage.displayState = stage.displayState == StageDisplayState.NORMAL
				? StageDisplayState.FULL_SCREEN_INTERACTIVE
				: StageDisplayState.NORMAL;
		} catch (err:Dynamic) {
			trace("fullscreen toggle failed: " + err);
		}
	}

	function onStageResize(_):Void {
		#if debug
		var win = openfl.Lib.application.window;
		trace("RESIZE stage=" + stage.stageWidth + "x" + stage.stageHeight + " window=" + win.width + "x" + win.height
			+ " scale=" + win.scale + " fullscreen=" + win.fullscreen
			+ " mode=" + (win.displayMode != null ? win.displayMode.width + "x" + win.displayMode.height : "?"));
		#end
		fitToStage();
	}

	/**
		Scales the game to the window, uniformly so nothing is stretched, and centres it -
		any window whose aspect ratio differs from DESIGN_WIDTH:DESIGN_HEIGHT gets even
		bars on the two leftover sides.
	**/
	private function fitToStage():Void {
		if (stage == null) return;
		var scale = Math.min(stage.stageWidth / DESIGN_WIDTH, stage.stageHeight / DESIGN_HEIGHT);
		if (scale <= 0) return;
		this.scaleX = this.scaleY = scale;
		this.x = Math.round((stage.stageWidth - DESIGN_WIDTH * scale) / 2);
		this.y = Math.round((stage.stageHeight - DESIGN_HEIGHT * scale) / 2);
	}

	public function hideCharacter():Void {
		if (character != null) {
			if (this.contains(character.mc)) {
				help.showTutorial(11);
				this.removeChild(character.mc);
			}
		}
	}

	public function showQuestManager():Void {
		this.addChild(questManager.mc);
		questManager.update();
		questManager.showFog();
		sound.playLoopEffect("TOWER_CRYSTAL_MUSIC");
		help.showTutorial(3);
		centerScreen(questManager.mc);
	}

	function innerCountIOError(param1:Event):Void {
		trace("innerCountIOError:" + param1);
	}

	public function showTower():Void {
		var _loc1_:Null<Dynamic> = null;
		hideMap();
		hideMenuScreen();
		this.addChild(tower.mc);
		tower.updateQuestIcon();
		sound.playMusic("TOWER_MUSIC");
		_loc1_ = help.showTutorial(2);
		if (!_loc1_) {
			_loc1_ = help.showTutorial(9);
			if (!_loc1_) {
				_loc1_ = help.showTutorial(19);
			}
		}
		if (frameMC != null) {
			this.setChildIndex(frameMC, this.numChildren - 1);
		}
	}

	function showNewPlayer():Void {
		hideOpeningScreen();
		newPlayer = new BambaNewPlayerScreen(this);
		this.addChild(newPlayer.mc);
		cornerScreen(newPlayer.mc);
		newPlayer.slideIn();
		sound.playMusic("MAP_MUSIC");
		frameMC.holesMC.gotoAndStop("no_order");
	}

	public function exitToOpeningScreen():Void {
		autoLogin = false;
		showOpeningScreen();
		opening.setOnStart();
	}

	function startNewPlayer():Void {
		if (finishLoading) {
			if (didLogin) {
				showCharacterBuild();
			} else {
				showNewPlayer();
			}
		} else {
			Heb.setText(opening.mc.loadingBarMC.msgDT, "ממתין לסיום טעינת נתונים");
		}
	}

	public function innerCount(eventCodeId:Int):Void {
		var _loc2_:String;
		var _loc3_:Int;
		var _loc4_:Dynamic;
		ERate.sendEvent(ToolID, eventCodeId);
		_loc2_ = "edcount";
		_loc3_ = eventTypeCodes.indexOf(eventCodeId);
		_loc4_ = eventTypeNames[_loc3_];
		//fscommand(_loc2_, _loc4_);
	}

	public function makeFullScreen(param1:MouseEvent):Void {
		var event:MouseEvent = param1;
		if (stage.displayState == StageDisplayState.NORMAL) {
			try {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			} catch (e:Dynamic) {
				trace("an error has occured. please modify the html file to allow fullscreen mode");
			}
		}
	}

	public function mainMenuClicked(param1:MouseEvent):Void {
		if (!msgShown) {
			sound.playEffect("GENERAL_WARNING");
			MsgBox.showYesNoBox("האם אתה בטוח שאתה רוצה לצאת מהמשחק?", showMainMenu);
		}
	}

	public function showMovie(param1:openfl.display.DisplayObject):Void {
		hideAllScreens();
		this.addChild(param1);
		param1.x = 30;
		param1.y = 72;
		addFrame();
		this.setChildIndex(frameMC, this.numChildren - 1);
		sound.stopAll();
	}

	function hideCharacterBuild():Void {
		if (characterBuild != null) {
			if (this.contains(characterBuild.mc)) {
				this.removeChild(characterBuild.mc);
			}
		}
	}

	public function openHelp(param1:MouseEvent):Void {
		if (!msgShown) {
			innerCount(27);
			help.showPage(1);
		}
	}

	public function showCharacter():Void {
		this.addChild(character.mc);
		help.showTutorial(10);
		centerScreen(character.mc);
		character.update();
	}

	public function finishFilesLoad():Void {
		finishLoading = true;
		opening.hideLoadingBar();
		trace("BambaMain.finishFilesLoad");
		if (didLogin) {
			startGame();
		}
	}

	function innerCountComplete(param1:Event):Void {
		trace("innerCountComplete");
	}

	function hideMap():Void {
		if (gameMap != null) {
			if (this.contains(gameMap.mc)) {
				this.removeChild(gameMap.mc);
			}
		}
	}

	public function hideStore():Void {
		if (store != null) {
			if (this.contains(store.mc)) {
				help.showTutorial(14);
				this.removeChild(store.mc);
			}
		}
	}

	public function finishEnemyAssetLoad():Void {
		sound.setLoadDungeonMusic([
			gameData.getCatalogDungeonData(currDongeonId).music,
			gameData.getCatalogDungeonData(currDongeonId).fightMusic
		]);
	}

	public function showUpgradeCrads():Void {
		this.addChild(upgradeSystem.mc);
		upgradeSystem.update();
		help.showTutorial(22);
		sound.playLoopEffect("TOWER_ALCHEMY_MUSIC");
		centerScreen(upgradeSystem.mc);
	}

	public function hideQuestManager():Void {
		var _loc1_:Bool = false;
		if (questManager != null) {
			if (this.contains(questManager.mc)) {
				if (gameData.playerData.currentQuestId != 0) {
					_loc1_ = help.showTutorial(4);
					if (!_loc1_) {
						_loc1_ = help.showTutorial(15);
					}
				}
				this.removeChild(questManager.mc);
			}
		}
	}

	public function showMainMenu():Void {
		innerCount(28);
		hideMovie();
		if (didLogin) {
			hideAllScreens();
			sound.stopAll();
			if (gameMap != null) {
				gameMap.setBabyAtTower();
			}
			showMenuScreen();
		} else {
			showOpeningScreen();
		}
	}

	function showMapContinue():Void {
		if (soundTimer != null) soundTimer.stop();
		// clearInterval(soundTimingInterval);
		hideTower();
		this.addChild(gameMap.mc);
		gameMap.setMap();
		centerScreen(gameMap.mc);
		sound.playMusic("MAP_MUSIC");
		msgShown = false;
	}

	function hideTower():Void {
		if (tower != null) {
			if (this.contains(tower.mc)) {
				this.removeChild(tower.mc);
			}
		}
	}

	function checkUser():Void {
		innerCount(1);
		userSharedObject = SharedObject.getLocal("Rlofe54836");
		if (userSharedObject.data.Rlofe54836 != 78512963482) {
			userSharedObject.data.Rlofe54836 = 78512963482;
			userSharedObject.flush();
			innerCount(11);
		}
		innerCount(10);
	}

	function showDungeon():Void {
		var _loc1_:Null<Dynamic> = null;
		if (soundTimer != null) soundTimer.stop();
		//clearInterval(soundTimingInterval);
		MsgBox.closeWaitBox();
		hideAllScreens(false);
		aDungeon.MC.visible = true;
		aDungeon.playDungeonMusic();
		_loc1_ = help.showTutorial(6);
		if (!_loc1_) {
			_loc1_ = help.showTutorial(16);
		}
	}

	public function hideMovie():Void {
		movie.stopMovie();
	}

	public function hideMagicBook():Void {
		if (magicBook != null) {
			if (this.contains(magicBook.mc)) {
				this.removeChild(magicBook.mc);
			}
		}
	}

	// param1 is null when the intro could not be displayed at all - see
	// BambaMovie.loadAndShowComplete. Typed rather than Dynamic so .x/.y are direct access.
	public function endMovie(param1:openfl.display.DisplayObject):Void {
		if (param1 != null && param1.parent == this) {
			this.removeChild(param1);
		}
		if (didLogin) {
			showMainMenu();
		} else {
			startNewPlayer();
		}
	}

	public function showCharacterBuild():Void {
		if (characterBuildTimer != null) {
			characterBuildTimer.stop();
		}
		help.resetTutorial();
		frameMC.holesMC.gotoAndStop("no_order");
		hideNewPlayer();
		hideMenuScreen();
		if (characterBuild == null) {
			characterBuild = new BambaCharacterBuildScreen(this);
		} else {
			characterBuild.reset();
		}
		this.addChild(characterBuild.mc);
		cornerScreen(characterBuild.mc);
		characterBuild.slideIn();
	}

	public function showMap():Void {
		if (this.contains(tower.mc)) {
			sound.playEffect("TOWER_TO_MAP");
			msgShown = true;
			soundTimer = new Timer(1500);
			soundTimer.run = showMapContinue;
			//soundTimingInterval = setInterval(showMapContinue, 1500);
		} else {
			showMapContinue();
		}
	}

	public function finishDungeonAssetLoad():Void {
		var _loc1_:BambaDungeonData = null;
		var _loc2_:BambaEnemy = null;
		var _loc3_:Null<Dynamic> = null;
		_loc1_ = gameData.getCatalogDungeonData(currDongeonId);
		if (questManager.currQuestDungeonId == currDongeonId) {
			currEnemyId = questManager.currQuestEnemyId;
			currDungeonDifficulty = questManager.currQuestDungeonDifficulty;
		} else if (_loc1_.currEnemyId != 0) {
			currEnemyId = _loc1_.currEnemyId;
			currDungeonDifficulty = _loc1_.currDungeonDifficulty;
		} else {
			currEnemyId = _loc1_.enemiesIds[Math.floor(Math.random() * _loc1_.enemiesIds.length)];
			currDungeonDifficulty = Math.floor(Math.random() * 3) + 1;
		}
		_loc2_ = Math.isNaN(currEnemyId) ? null : gameData.getCatalogEnemy(currEnemyId, 1);
		if (_loc2_ == null) {
			// No enemy in this dungeon (or an id the catalog doesn't know): don't leave the
			// previous dungeon's enemy art behind.
			BambaAssets.enemyArt = null;
			finishEnemyAssetLoad();
		} else {
			_loc3_ = _loc2_.assetFileName;
			gameLoader.loadEnemyAssetStart(_loc3_);
		}
	}

	public function finishLoadPlayerData():Void {
		didLogin = true;
		Heb.setText(opening.mc.loadingBarMC.msgDT, "...שם המשתמש נמצא. טוען משחק");
		trace("BambaMain.finishLoadPlayerData");
		if (finishLoading) {
			startGame();
		}
	}

	// param1 was Dynamic in the AS3 port, which made every .x/.y/.width access reflective;
	// on hxcpp that throws "Invalid field:x". A real type compiles to direct property access.
	public function centerScreen(param1:openfl.display.DisplayObject):Void {
		if (frameMC != null) {
			this.setChildIndex(frameMC, this.numChildren - 1);
		}
		// orgWidth/orgHeight were AS3 dynamic properties bolted onto clips at runtime. Every
		// assignment to them is currently commented out across the port, so this is always null,
		// but read it reflectively so the branch still works if those are restored.
		var orgWidth:Dynamic = Reflect.field(param1, "orgWidth");
		var orgHeight:Dynamic = Reflect.field(param1, "orgHeight");
		if (orgWidth == null || orgHeight == null) {
			param1.x = (945 - param1.width) / 2;
			param1.y = (650 - param1.height) / 2;
		} else {
			param1.x = (945 - (orgWidth : Float)) / 2;
			param1.y = (650 - (orgHeight : Float)) / 2;
		}
	}

	// Typed rather than Dynamic: Dynamic makes .x/.y reflective, which throws "Invalid field:x"
	// on hxcpp once DCE has trimmed the reflection entries. Same fix as centerScreen().
	public function cornerScreen(param1:openfl.display.DisplayObject):Void {
		if (frameMC != null) {
			this.setChildIndex(frameMC, this.numChildren - 1);
		}
		param1.x = 29;
		param1.y = 72;
	}

	function addFrame():Void {
		if (frameMC == null) {
			frameMC = new GeneralFrame();
			ButtonUpdater.setButton(frameMC.helpMC, openHelp);
			ButtonUpdater.setButton(frameMC.mainMenuMC, mainMenuClicked);
			sound.setMusicVolumeBar(frameMC.musicVolumeMC);
			sound.setEffectsVolumeBar(frameMC.effectsVolumeMC);
			this.addChild(frameMC);
		} else {
			frameMC.visible = true;
		}
	}

	function hideFrame():Void {
		if (frameMC != null) {
			frameMC.visible = false;
		}
	}

	public function startGame():Void {
		//var _loc1_:Null<Dynamic> = null;
		if (finishLoading && didLogin) {
			// Before the branch: logging into a registered account that has no character yet
			// goes to startNewPlayer() -> showCharacterBuild(), which reads frameMC.holesMC.
			// That path only became reachable once login started succeeding (see
			// utils.LocalPlayerStore); addFrame() and both init() calls are idempotent.
			addFrame();
			MsgBox.init(this);
			PlayerDataUpdater.init(this);
			if (gameData.playerData.pName == "") {
				startNewPlayer();
			} else {
				if (menu == null) {
					menu = new BambaMenuScreen(this);
				}
				tower = new BambaTower(this);
				questManager = new BambaQuestManager(this);
				magicBook = new BambaMagicBook(this);
				upgradeSystem = new BambaUpgradeSystem(this);
				gameMap = new BambaMap(this);
				character = new BambaCharacterScreen(this);
				store = new BambaStore(this);
				gameData.playerData.setLevelDependingData();
				var _orderCode = "order" + gameData.playerData.orderCode;
				frameMC.holesMC.gotoAndStop(_orderCode);
				hideCharacterBuild();
				hideOpeningScreen();
				showMenuScreen();
			}
		} else if (!finishLoading) {
			Heb.setText(opening.mc.loadingBarMC.msgDT, "רגע... עוד לא סיימנו לטעון");
		}
	}

	function hideNewPlayer():Void {
		if (newPlayer != null) {
			if (this.contains(newPlayer.mc)) {
				this.removeChild(newPlayer.mc);
			}
		}
	}

	public function hideUpgradeCrads():Void {
		if (upgradeSystem != null) {
			if (this.contains(upgradeSystem.mc)) {
				this.removeChild(upgradeSystem.mc);
			}
		}
	}

	public function showMenuScreen():Void {
		hideCharacterBuild();
		hideMenuScreen();
		sound.playMusic("MAP_MUSIC");
		if (menu == null) {
			menu = new BambaMenuScreen(this);
		}
		this.addChild(menu.mc);
		menu.update();
		cornerScreen(menu.mc);
		menu.slideIn();
	}

	public function hideAllScreens(shouldHide:Bool = true):Void {
		if (shouldHide) {
			if (aDungeon != null) {
				aDungeon.exitDungeon();
			}
		}
		hideMap();
		hideTower();
		hideStore();
		hideCharacter();
		hideUpgradeCrads();
		hideMagicBook();
		hideQuestManager();
		hideMenuScreen();
		hideOpeningScreen();
		hideCharacterBuild();
		hideNewPlayer();
	}

	function hideMenuScreen():Void {
		if (menu != null) {
			if (this.contains(menu.mc)) {
				this.removeChild(menu.mc);
			}
		}
	}

	public function closeDungeon():Void {
		if (this.contains(dungeonMC)) {
			this.removeChild(dungeonMC);
			gameLoader.savePlayerData();
			showMap();
		}
		try {
		
		} catch (e:Dynamic) {
			trace("close doungen error" + e);
		}
	}

	public function getHTMLvars():Void {
		ToolID = "SBCKOS";
	}

	public function showMagicBook():Void {
		this.addChild(magicBook.mc);
		magicBook.update();
		help.showTutorial(20);
		sound.playLoopEffect("TOWER_BOOK_MUSIC");
		centerScreen(magicBook.mc);
	}

	function hideOpeningScreen():Void {
		if (opening != null) {
			if (this.contains(opening.mc)) {
				this.removeChild(opening.mc);
			}
		}
	}

	public function finishDungeonMusicLoad():Void {
		if (aDungeon != null) {
			aDungeon.clearEvents();
		}
		dungeonMC = new DungeonMain();
		this.addChildAt(dungeonMC, 0);
		if (questManager.currQuestDungeonId == currDongeonId) {
			aDungeon = new BambaDungeon(this, dungeonMC, questManager.currQuestDungeonId, questManager.currQuestDungeonDifficulty,
				questManager.currQuestEnemyId, questManager.currSpecialEnemy, questManager.currMarkBoss, questManager.currMarkAllEnemies,
				questManager.currSpecialTreasure);
		} else {
			aDungeon = new BambaDungeon(this, dungeonMC, currDongeonId, currDungeonDifficulty, currEnemyId, false, false, false, false);
		}
		sound.playEffect("MAP_TO_MAZE");
		aDungeon.MC.visible = false;
		soundTimer = new Timer(1200);
		soundTimer.run = showDungeon;
		// soundTimingInterval = setInterval(showDungeon, 1200);
	}

	public function initGeneral():Void {
		MsgBox.init(this);
		PlayerDataUpdater.init(this);
	}

	public function showStore():Void {
		this.addChild(store.mc);
		help.showTutorial(12);
		centerScreen(store.mc);
		store.update();
		sound.playLoopEffect("TOWER_STORE_MUSIC");
	}

	public function showOpeningScreen():Void {
		sound.stopAll();
		didLogin = false;
		if (opening == null) {
			opening = new BambaOpeningScreen(this);
		}
		this.addChild(opening.mc);	
	}

	public function showCharacterBuildAfterNewPlayer():Void {
		newPlayer.slideOut();
		characterBuildTimer = new Timer(600);
		characterBuildTimer.run = showCharacterBuild;
		//showCharacterBuildInteval = setInterval(showCharacterBuild, 600);
	}

	public function startDungeon(dugeonId:Float):Void {
		//var _loc2_:Float;
		//var _loc3_:BambaDungeonData;
		//_loc2_ = 100 + dugeonId;
		currDongeonId = dugeonId;
		var _dungeonData = gameData.getCatalogDungeonData(currDongeonId);
		gameLoader.loadDungeonAssetStart(_dungeonData.assetFileName);
	}
}
