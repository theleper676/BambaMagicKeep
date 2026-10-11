package;

import openfl.Assets;
import haxe.xml.Access;
import sys.io.File;
import swf.exporters.animate.AnimateLibrary;
import openfl.Lib;
import haxe.Timer;
import openfl.display.*;
import openfl.errors.*;
import openfl.events.*;
import openfl.external.ExternalInterface;
import openfl.net.URLLoader;
import openfl.net.URLRequest;
import openfl.net.URLVariables;
import openfl.utils.*;
import general.Heb;
import general.MsgBox;
import lime.ui.FileDialog;
import lime.ui.FileDialogType;
import utils.LocalPlayerStore;

@:access(swf.exporters.animate.AnimateLibrary) // reads `uuid` to recognise baby.swf
class BambaLoader extends EventDispatcher {
	private var generalDataFileName:String;

	private var openingAssets:Array<String> = [];

	var continueTime:Float;

	var xmlFilesIndex:Int;

	public var game:BambaMain;

	public var loadingCounter:Float;

	private var playerDataSource:String;

	private var updatePlayerDataSource:String;

	var assetsIndex:Int;

	private var sendPassSource:String;

	var msgCounter:Int;

	private var assetsPath:String;

	private var forgetPassSource:String;

	var lastLoadingCounter:Float;

	var currBytes:Float;


	var loadingMsgs:Array<Dynamic>;

	var fileSizes:Array<Dynamic>;

	var xmlFunctionNames:Array<String>;

	var continueLoadingIntervalTimer: Timer;
	//var continueLoadingInterval:Float;

	var currFileName:String;

	var assets:Array<Array<String>>;

	var totalBytes:Float;

	public var soundsPath:String;

	private var soundsFileName:String;

	var xmlFiles:Array<String>;

	private var paramFile:String = "params.xml";

	var tempMail:String;

	public var currFunctionName:String;

	private var xmlPath:String;

	private var dictionaryFileName:String;

	var currAsset:Array<String>;

	var currLoadXMLFunctionName:String;


	private var newPlayerDataSource:String;

	var currLoader:Dynamic;

	public function new(mainGame:BambaMain) {
		paramFile = "params.xml";
		super();
		game = mainGame;
		xmlFilesIndex = 0;
		assetsIndex = 0;
		msgCounter = 0;
		loadParams();
	}

	public static inline function extractAssetElements (root:Access, nodeName:String):Array<String> {
		var _assetArray:Array<String> = [];
		for (element in root.elements) {
			if(element.elements.hasNext()) {
				if(element.name == nodeName) {
					for (value in element.elements) {
						_assetArray.push(value.innerData);
					}
				}
			} 
		}
		return _assetArray;
	}
	
	function loadAssets():Void {
		
		currFunctionName = "loadAssets";
		++loadingCounter;
		if(assetsIndex < assets.length) {
			currAsset = assets[assetsIndex];
			var _currAssetSwf = currAsset[0];
			var _assetPath = Assets.getPath(_currAssetSwf);
			trace("loading assets of " + _currAssetSwf);
			Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter]);
			AnimateLibrary.loadFromFile(_assetPath)
			.onProgress((bytesLoaded, bytesTotal) -> {
				loadAssetsProgress(bytesLoaded, bytesTotal);
			})
			.onError((error) -> {
				showIOError(error);
			})
			.onComplete((library) -> {
				trace(library);
				// Symbol class names inside the SWF do not match the generated Haxe packages;
				// rebind them before anything from this library is instantiated.
				utils.SymbolClassBinder.bind(library);
				utils.BitmapSmoothing.apply(library);
				utils.FontBinder.apply(library);
				// Their frame scripts are one-liners (stop at the end of each animation, the dice
				// faces, each card part holding its first frame...) that never ran, so clips cycled
				// through every frame. newPlayer and towerScreens also carry Flash UI-component
				// code, so they are left as they were.
				utils.TimelineRepairs.apply(library);
				if (!SCRIPTS_LEFT_ALONE.contains(library.uuid)) utils.FrameScripts.restore(library);
				loadAssetsComplete();
			});
		} else {
			loadSoundsData();
		}
		/* var tempCurrAssetString:Null<Dynamic>;
		var loader:Loader;
		var request:URLRequest;
		currFunctionName = "loadAssets";
		++loadingCounter;
		if (assetsIndex < assets.length) {
			tempCurrAssetString = assets[assetsIndex];
			currAsset = tempCurrAssetString.split(",");
			Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter]);
			loader = new Loader();
			request = new URLRequest(assetsPath + "/" + currAsset[0]);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadAssetsComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadAssetsProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, showIOError);
			currLoader = loader;
			try {
				loader.load(request);
			} catch (error:Dynamic) {
				trace("loading asset error occured:" + error.message);
				//game.errorDT.text = error.errorID + ":" + error.name + ":" + error.message;
			}
		} else {
			loadSoundsData();
		} */
	}

	function loadPlayerDataComplete(errorCode:Int):Void {
		if (errorCode == LocalPlayerStore.OK) {
			game.innerCount(14);
			game.finishLoadPlayerData();
		} else {
			game.opening.showErrorMsg(errorCode);
		}
	}

	/** Reveals the folder the save files live in, for a player who wants to find or copy one. **/
	public function browseSavesFolder():Void {
		var dir = LocalPlayerStore.savesDirectory();
		if (dir == null) {
			MsgBox.show("פתיחת תיקיית השמירות אינה נתמכת כאן");
			return;
		}
		var dialog = new FileDialog();
		if (!dialog.browse(FileDialogType.OPEN_DIRECTORY, null, dir, "תיקיית השמירות")) {
			trace("BambaLoader: no native file dialog on this target");
		}
	}

	function loadParams():Void {
		currFunctionName = "loadParams";
		try {
			var paramXMLPath = Assets.getPath("params");
			var paramXMLContent:String = File.getContent(paramXMLPath);
			var paramsXml = Xml.parse(paramXMLContent);
			loadParamsComplete(paramsXml);
		} catch (error:ArgumentError) {
			trace("An ArgumentError has occurred.");
		} catch (error:SecurityError) {
			trace("A SecurityError has occurred.");
		}
	}

	function chackContinueLoadingNeeded():Void {
		trace("loadingCounter:" + loadingCounter);
		if (lastLoadingCounter == loadingCounter) {
			continueLoading();
		} else {
			lastLoadingCounter = loadingCounter;
		}
	}

	function loadOpeningAssetsComplete():Void {
		
		var libraryPath = Assets.getPath("openingAssets");
		AnimateLibrary.loadFromFile(libraryPath).onComplete((library)-> {
			utils.SymbolClassBinder.bind(library);
			utils.BitmapSmoothing.apply(library);
			utils.FontBinder.apply(library);
			for (i in 1...openingAssets.length) {
				var assetName = openingAssets[i];
				game.gameAssets.defineAsset(assetName);
			}
			game.showOpeningScreen();  
			loadDictionary();
        });
		
	}

	function loadDictionary():Void {
		trace(game.opening);
		if(game.opening.mc.loadingBarMC != null) {
			Heb.setText(game.opening.mc.loadingBarMC.loaderDT, "טוען מילון נתונים");
		}
		currFunctionName = "loadDictionary";
		try{
			var dictionaryXMLpath = Assets.getPath("dictionary");
			var dictionaryXMLContent:String = File.getContent(dictionaryXMLpath);
			var dictionary = Xml.parse(dictionaryXMLContent);
			loadDictionaryComplete(dictionary);
		}
		catch (error: ArgumentError) {
			trace("An ArgumentError has occurred.");
		}
	}

	/**
		Registers the account locally instead of POSTing it to `newPlayerDataSource`.

		The reply is delivered on a later frame, the way the `URLLoader` used to deliver it:
		this runs inside the new-player screen's own click/Enter handler, and the success path
		slides that screen out and builds the character screen, so finishing the work outside
		the handler keeps the original control flow.
	**/
	public function sendNewPlayerData(userName:String, password:String, mail:String, birthDate:String):Void {
		game.gameData.playerData.setUserPass(userName, password);
		MsgBox.showWaitBox("יוצר משתמש חדש");
		Timer.delay(function() {
			sendNewPlayerDataComplete(LocalPlayerStore.createAccount(userName, password, mail, birthDate));
		}, 1);
	}

	function loadGeneralDataComplete():Void {
		currBytes += Std.parseFloat(fileSizes[msgCounter]);
		setLoaderGraphics(currBytes / totalBytes);
		++msgCounter;
		++loadingCounter;
		game.gameData.loadGeneralData();
		loadXMLFile();
	}

	function loadAssetsProgress(bytesLoaded:Int, bytesTotal:Int):Void {
		var _bytes:Float;
		var _precent:Float;
		_bytes = bytesLoaded / bytesTotal;
		_precent = Math.floor(_bytes * 100);
		Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter] + " %" + _precent);
		setLoaderGraphics((currBytes + _bytes * Std.parseFloat(fileSizes[msgCounter])) / totalBytes);
		++loadingCounter;
	}

	/**
		Loads a per-dungeon / per-enemy art library. The AS3 original pulled these SWFs in with a
		Loader, which cannot parse a SWF on native targets - it never completed, so the wait box
		sat at 0% forever. They are converted libraries (project.xml registers each zip under
		its original .swf name), loaded the same way as the startup assets.

		`onDone(null)` when the file is not in the build or fails to load.
	**/
	function loadArtLibrary(fileName:String, onProgress:Int->Void, onDone:AnimateLibrary->Void):Void {
		if (loadedArtLibraries.exists(fileName)) {
			onDone(loadedArtLibraries.get(fileName));
			return;
		}
		if (!Assets.exists(fileName)) {
			trace("BambaLoader: art library '" + fileName + "' is not in this build");
			onDone(null);
			return;
		}
		AnimateLibrary.loadFromFile(Assets.getPath(fileName))
			.onProgress((bytesLoaded, bytesTotal) -> {
				++loadingCounter;
				if (bytesTotal > 0) onProgress(Math.floor(bytesLoaded / bytesTotal * 100));
			})
			.onError((error) -> {
				showIOError(error);
				onDone(null);
			})
			.onComplete((library) -> {
				utils.SymbolClassBinder.bind(library);
				utils.BitmapSmoothing.apply(library);
				utils.FontBinder.apply(library);
				utils.TimelineRepairs.apply(library);
				utils.FrameScripts.restore(library);
				loadedArtLibraries.set(fileName, library);
				onDone(library);
			});
	}

	var loadedArtLibraries:Map<String, AnimateLibrary> = new Map();

	static final SCRIPTS_LEFT_ALONE = [
		"ID11jSMEMP2dDrzhS39l", // newPlayer.swf
		"40YIf0lE7lVtVgPBVcJt" // towerScreens.swf
	];

	public function loadDungeonAsset():Void {
		currFunctionName = "loadDungeonAsset";
		++loadingCounter;
		MsgBox.showWaitBox(game.gameData.dictionary.LOADING_DUNGEON_MSG);
		MsgBox.updateWaitBox(0);
		loadArtLibrary(currFileName, pct -> MsgBox.updateWaitBox(pct), function(library) {
			if (library != null) {
				BambaAssets.dungeonArt = library;
				loadDungeonAssetsComplete(null);
			} else {
				MsgBox.closeWaitBox();
				MsgBox.show("הגרפיקה של המבוך הזה חסרה במשחק");
			}
		});
	}

	public function loadEnemyAssetStart(param1:Dynamic):Void {
		currFileName = param1;
		loadEnemyAsset();
	}

	function loadAssetsComplete():Void {
		trace("loading asset complete");
		++loadingCounter;
		currBytes += Std.parseFloat(fileSizes[msgCounter]);
		setLoaderGraphics(currBytes / totalBytes);
		++msgCounter;
		for (i in 1...currAsset.length) {
			var _assetToDefine = currAsset[i];
			game.gameAssets.defineAsset(_assetToDefine);
		}
		++assetsIndex;
		loadAssets();
		/* var _assetToDefine = currAsset[_assetCounter];
		trace(_assetToDefine); */
		/* while (_assetCounter < currAsset.length) {
			var _assetToDefine = currAsset[_assetCounter];
			trace(_assetToDefine);
			game.gameAssets.defineAsset(_assetToDefine, BambaMain);
			_assetCounter++;
		}
		++assetsIndex;
		loadAssets(); */
		/* var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		++loadingCounter;
		currBytes += Std.parseFloat(fileSizes[msgCounter]);
		setLoaderGraphics(currBytes / totalBytes);
		++msgCounter;
		_loc2_ = 1;
		while (_loc2_ < currAsset.length) {
			_loc3_ = currAsset[_loc2_];
			game.gameAssets.defineAsset(_loc3_, BambaMain);
			_loc2_++;
		}
		++assetsIndex; */
		//loadAssets();
	}

	function loadParamsComplete(paramXml:Xml):Void {
		var root = new Access(paramXml.firstElement());
		var node  = root.node;
		
		var _playerLevelsFileName:String;
		var _magicBookFileName :String;
		var _cardsFileName:String;
		var _enemiesFileName:String;
		var _enemiesLevelsFileName:String;
		var _itemsBaseFileName:String;
		var _itemsFileName:String;
		var _storeItemsFileName:String;
		var _prizesFileName:String;
		var _surprisesFileName:String;
		var _dungeonsDataFileName:String;
		var _questsFileName:String;
		var _helpFileName:String;
		var _generalAssets:Array<String> =[];
		var _newPlayerAssets:Array<String> = [];
		var _menuAssets:Array<String> = [];
		var _cardsAssets:Array<String> = [];
		var _itemsAssets:Array<String> = [];
		var _babyAssets:Array<String> = [];
		var _fightGraphicsAssets:Array<String> = [];
		var _dungeonIconsAssets:Array<String> = [];
		var _towerAssets:Array<String> = [];
		var _mapAssets:Array<String> = [];
		var _helpAssets:Array<String> = [];
			
		//local vars
		_playerLevelsFileName = "playerLevels";
		_magicBookFileName = "magicBook";
		_cardsFileName = "cards";
		_enemiesFileName = "enemies";
		_enemiesLevelsFileName = "enemiesLevels";
		_itemsBaseFileName = "itemsBase";
		_itemsFileName = "items";
		_storeItemsFileName = "storeItems";
		_prizesFileName = "prizes";
		_surprisesFileName = "suprises";
		_dungeonsDataFileName = "dungeonsData";
		_questsFileName = "quests";
		_helpFileName = "help";

		dictionaryFileName = node.dictionaryfilename.innerData;
		generalDataFileName = node.generaldatafilename.innerData;
		soundsFileName = node.soundsfilename.innerData;
		playerDataSource = node.playerDataSource.innerData;
		newPlayerDataSource = node.newPlayerDataSource.innerData;
		updatePlayerDataSource = node.updatePlayerDataSource.innerData;
		forgetPassSource = node.forgetPassSource.innerData;
		sendPassSource = node.forgetPassSource.innerData;
		xmlFiles = [
			_playerLevelsFileName,
			_magicBookFileName,
			 _cardsFileName,
			 _enemiesFileName,
			 _enemiesLevelsFileName,
			 _itemsBaseFileName,
			 _itemsFileName,
			 _storeItemsFileName,
			 _prizesFileName,
			 _surprisesFileName,
			 _dungeonsDataFileName,
			 _questsFileName,
			 _helpFileName,
		];
	
		/* for (element in node.openingassets.elements) {
			openingAssets.push(element.innerData);
		};
		for (element in node.generalassets.elements) {
			_generalAssets.push(element.innerData);
		};
		for (element in node.newplayerassets.elements) {
			_newPlayerAssets.push(element.innerData);
		}; */

		
		xmlPath = "assets/xmls";
		soundsPath = "assets/sounds";
		xmlFunctionNames = [
			"buildPlayerLevelsCatalog",
			"buildMagicCatalog",
			"buildCardsCatalog",
			"buildEnemiesCatalog",
			"buildEnemiesLevelsCatalog",
			"buildItemsBaseCatalog",
			"buildItemsCatalog",
			"buildStoreItemsCatalog",
			"buildPrizesCatalog",
			"buildSurprisesCatalog",
			"buildDungeonsDataCatalog",
			"buildQuestsCatalog",
			"buildHelpCatalog"
		];
		//dictionaryFileName = _loc2_.dictionaryFileName;
		//generalDataFileName = _loc2_.generalDataFileName;
		//soundsFileName = _loc2_.soundsFileName;
		//playerDataSource = _loc2_.playerDataSource;
		//newPlayerDataSource = _loc2_.newPlayerDataSource;
		//updatePlayerDataSource = _loc2_.updatePlayerDataSource;
		//forgetPassSource = _loc2_.forgetPassSource;
		//sendPassSource = _loc2_.sendPassSource;
		//openingAssets = _loc2_.openingAssets.split(",");
		//xmlPath = _loc2_.xmlPath;
		//assetsPath = _loc2_.assetsPath;
		//soundsPath = _loc2_.soundsPath;
		//_loc3_ = _loc2_.playerLevelsFileName;
		//_loc4_ = _loc2_.magicBookFileName;
		//_loc5_ = _loc2_.cardsFileName;
		//_loc6_ = _loc2_.enemiesFileName;
		// _loc7_ = _loc2_.enemiesLevelsFileName;
		//_loc8_ = _loc2_.itemsBaseFileName;
		//_loc9_ = _loc2_.itemsFileName;
		//_loc10_ = _loc2_.storeItemsFileName;
		//_loc11_ = _loc2_.prizesFileName;
		//_loc12_ = _loc2_.surprisesFileName;
		//_loc13_ = _loc2_.dungeonsDataFileName;
		//_loc14_ = _loc2_.questsFileName;
		//_loc15_ = _loc2_.helpFileName;
		
		//_loc16_ = _loc2_.generalAssets;
		
		//_loc17_ = _loc2_.newPlayerAssets;
		openingAssets = extractAssetElements(root, "openingassets");
		_generalAssets = extractAssetElements(root, "generalassets");
		_generalAssets = extractAssetElements(root, "generalassets");
		_newPlayerAssets = extractAssetElements(root,"newplayerassets");
		_menuAssets = extractAssetElements(root,"menuassets");
		_cardsAssets =  extractAssetElements(root, "cardsassets");
		_itemsAssets = extractAssetElements(root, "itemsassets");
		_babyAssets = extractAssetElements(root, "babyassets");
		_fightGraphicsAssets = extractAssetElements(root, "fightgraphicsassets");
		_dungeonIconsAssets = extractAssetElements(root, "dungeoniconsassets");
		_towerAssets = extractAssetElements(root, "towerassets");
		_mapAssets = extractAssetElements(root, "mapassets");
		_helpAssets = extractAssetElements(root, "helpassets");
		//_loc18_ = _loc2_.menuAssets;
		//_loc19_ = _loc2_.cardsAssets;
		// _loc20_ = _loc2_.itemsAssets;
		//_loc21_ = _loc2_.babyAssets;
		//_loc22_ = _loc2_.fightGraphicsAssets;
		//_loc23_ = _loc2_.dungeonIconsAssets;
		//_loc24_ = _loc2_.towerAssets;
		//_loc25_ = _loc2_.mapAssets;
		//_loc26_ = _loc2_.helpAssets;
		assets = [
			_generalAssets,
			_newPlayerAssets,
			_menuAssets,
			_cardsAssets,
			_itemsAssets,
			_babyAssets,
			_fightGraphicsAssets,
			_dungeonIconsAssets,
			_towerAssets,
			_mapAssets,
			_helpAssets
		];
		loadOpeningAssets();
		var libraryPath = Assets.getPath("openingAssets");
		AnimateLibrary.loadFromFile(libraryPath);
		var introPath = Assets.getPath("IntroBamba");
		game.movie.setMovieAsset(introPath);	
	}

	public function loadDungeonAssetStart(param1:Dynamic):Void {
		currFileName = param1;
		loadDungeonAsset();
	}

	function loadXMLFile():Void {
		var currentXmlPath:String;
		currFunctionName = "loadXMLFile";
		++loadingCounter;
		if (xmlFilesIndex < xmlFiles.length) {
			currFileName = xmlFiles[xmlFilesIndex];
			Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter]);
			currLoadXMLFunctionName = xmlFunctionNames[xmlFilesIndex];
			try {
				//currentXmlPath = Assets.getPath(currFileName);
				//var xml = Xml.parse(currentXmlPath);
				loadXMLComplete();
			} catch (error:Dynamic) {
				trace(error);
				trace("XML load error: " + error.message);
				//game.errorDT.text = error.errorID + ":" + error.name + ":" + error.message;
			}
		} else {
			loadAssets();
		}
	}

	public function loadDictionaryComplete(dictionaryXml:Xml):Void {
		game.gameData.loadDictionary(dictionaryXml);
		loadingMsgs = game.gameData.dictionary.LOADING_MSGS.split(",");
		fileSizes = game.gameData.dictionary.LOADING_FILE_SIZES.split(",");
		totalBytes = 0;
		var i  = 0;
		while (i < fileSizes.length) {
			totalBytes += Std.parseFloat(fileSizes[i]);
			i++;
		}
		currBytes = 0;
		setContinueLoading();
		loadGeneralData();
	}

	function loadFinished():Void {
		finishContinueLoading();
		Heb.setText(game.opening.mc.loadingBarMC.loaderDT, game.gameData.dictionary.LOADING_END_MSG);
		game.opening.mc.loadingBarMC.flareMC.stop();
		game.opening.mc.loadingBarMC.flareMC.visible = false;
		currFunctionName = "loadFinished";
		game.finishFilesLoad();
	}

	function finishContinueLoading():Void {
		// AS3 clearInterval() on an unset interval was a no-op; Timer.stop() on null segfaults.
		if (continueLoadingIntervalTimer != null) {
			continueLoadingIntervalTimer.stop();
			continueLoadingIntervalTimer = null;
		}
		// clearInterval(continueLoadingInterval);
	}

	/**
		Writes progress to the local store instead of POSTing to `updatePlayerDataSource`.
		Synchronous: there is no screen to keep responsive, and every caller (leaving a dungeon,
		buying from the store, brewing magic, finishing the character) expects the save to have
		happened by the time it continues.

		A failed write is reported, because it means lost progress - the same reason the server
		version surfaced its error message.
	**/
	public function savePlayerData():Void {
		if (!LocalPlayerStore.saveFrom(game.gameData.playerData)) {
			MsgBox.show("לא הצלחנו לשמור את ההתקדמות שלך");
		}
	}

	function loadSoundsData():Void {
		var _loc1_:URLRequest = null;
		var _loc2_:URLLoader = null;
		currFunctionName = "loadSoundsData";
		++loadingCounter;
		Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter]);
		_loc1_ = new URLRequest(xmlPath + "/" + soundsFileName);
		_loc2_ = new URLLoader();
		_loc2_.addEventListener(Event.COMPLETE, loadSoundsDataComplete);
		currLoader = _loc2_;
		_loc2_.load(_loc1_);
	}

	
	function continueLoading():Void {
		var currCompleteFunctionName:Dynamic = null;

		trace("BambaLoader.continueLoading:" + currFunctionName);
		// AS3 clearInterval() on an unset interval was a no-op; Timer.stop() on null segfaults.
		if (continueLoadingIntervalTimer != null) continueLoadingIntervalTimer.stop();
		//var arrayAccess:Function = Reflect.field(this, currCompleteFunctionName);
		currCompleteFunctionName = currFunctionName + "Complete";
		//currLoader.removeEventListener(Event.COMPLETE, arrayAccess());
		continueTime += 500;
		continueLoadingIntervalTimer = new Timer(continueTime);
		continueLoadingIntervalTimer.run = chackContinueLoadingNeeded;
		// continueLoadingInterval = setInterval(chackContinueLoadingNeeded, continueTime);
		//loadDictionaryComplete();
	}

	function sendNewPlayerDataComplete(errorCode:Int):Void {
		MsgBox.closeWaitBox();
		if (errorCode == LocalPlayerStore.OK) {
			game.showCharacterBuildAfterNewPlayer();
			return;
		}
		switch (errorCode) {
			case LocalPlayerStore.ERR_NAME_TAKEN:
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_NAME_EXISTING);
			case LocalPlayerStore.ERR_ILLEGAL_MAIL:
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_ILLEGAL_MAIL);
			case LocalPlayerStore.ERR_MAIL_TAKEN:
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_MAIL_EXISTING);
			default:
				trace("sendNewPlayerDataComplete: unexpected error code " + errorCode);
		}
	}

	/**
		Looks the address up in the local store instead of POSTing to `forgetPassSource`.

		There is no mail to send, so a match shows the credentials on the login screen - the
		only thing that can actually help a player offline. Previously this endpoint was set to
		"local" in params.xml and always claimed the mail had been sent, whatever was typed.
	**/
	public function forgetPass(mail:String):Void {
		tempMail = mail;
		Timer.delay(function() {
			var owner = LocalPlayerStore.mailOwner(mail);
			if (owner == null) {
				game.opening.showForgetPassErrorMsg(LocalPlayerStore.ERR_MAIL_UNKNOWN);
			} else {
				game.opening.showLocalCredentials(owner.user, owner.pass);
			}
		}, 1);
	}

	function loadXMLComplete():Void {
		var gameDataAccessFunction:Function = Reflect.field(game.gameData,currLoadXMLFunctionName);
		++loadingCounter;
		currBytes += Std.parseFloat(fileSizes[msgCounter]);
		setLoaderGraphics(currBytes / totalBytes);
		++msgCounter;
		gameDataAccessFunction();
		++xmlFilesIndex;
		loadXMLFile();
	}

	function loadOpeningAssets():Void {
		loadOpeningAssetsComplete();
	}

	function loadEnemyAssetsComplete(param1:Event):Void {
		++loadingCounter;
		finishContinueLoading();
		game.finishEnemyAssetLoad();
	}

	function setLoaderGraphics(precentComplete:Float):Void {
		game.opening.mc.loadingBarMC.flareMC.x = 800 - 800 * precentComplete;
		game.opening.mc.loadingBarMC.maskMC.width = 800 * precentComplete;
		game.opening.mc.loadingBarMC.maskMC.x = 800 - 800 * precentComplete;
	}

	function showSecurityError(error:SecurityErrorEvent):Void {
		trace("security error:" + error.target.toString() );
		//game.errorDT.text = "SecurityErrorEvent";
	}

	/**
		Opens a save file instead of POSTing credentials to `playerDataSource`.

		A native Open dialog replaces the user name and password: the player picks one of the
		`.bmksave` files under `LocalPlayerStore.savesDirectory()`, and that file becomes the
		session's save. `FileDialog.browse()` runs the dialog on a worker thread and dispatches
		back on the main thread, so the reply arrives on a later frame exactly as the old
		`URLLoader` reply did.

		`browse()` returns false on targets with no native dialog - consoles among them, even
		where `LocalPlayerStore` can otherwise reach a filesystem just fine. There is no way to
		let the player choose a file there, so `loadPlayerDataNoDialog()` continues whichever
		save was played last, or creates one, instead of leaving login a dead end.
	**/
	public function loadPlayerData():Void {
		// In-game picker instead of lime.ui.FileDialog: native dialogs on Windows cannot sit
		// on top of a fullscreen window, and open the game drops out of fullscreen when they
		// appear. The picker is part of the game's own display list, so it works identically
		// in windowed, borderless and exclusive-fullscreen modes.
		utils.SavePicker.show(game,
			function(path:String) {
				if (LocalPlayerStore.loadFile(path, game.gameData.playerData)) {
					loadPlayerDataComplete(LocalPlayerStore.OK);
				} else {
					MsgBox.show("לא הצלחנו לפתוח את קובץ השמירה");
				}
			},
			function() {
				trace("BambaLoader: save file selection cancelled");
			}
		);
	}

	/**
		No native Open dialog: continues the most recently played save if one exists, or
		silently creates one - the same empty-`pName` state a server sign-up used to leave the
		game in, which `BambaMain.startGame()` already sends to the character builder.
	**/
	function loadPlayerDataNoDialog():Void {
		var path = LocalPlayerStore.mostRecentSave();
		if (path != null && LocalPlayerStore.loadFile(path, game.gameData.playerData)) {
			loadPlayerDataComplete(LocalPlayerStore.OK);
			return;
		}
		var errorCode = LocalPlayerStore.createAccount("Player", "", "", "");
		if (errorCode == LocalPlayerStore.ERR_IO) {
			// No save to continue and no filesystem to create one on either - this target has
			// no save/load story at all, which a bare trace would leave invisible in the field.
			MsgBox.show("שמירת וטעינת משחק אינה נתמכת כאן");
			return;
		}
		sendNewPlayerDataComplete(errorCode);
	}

	public function loadEnemyAsset():Void {
		currFunctionName = "loadEnemyAsset";
		++loadingCounter;
		MsgBox.updateWaitBoxTxt(game.gameData.dictionary.LOADING_ENEMY_MSG);
		MsgBox.updateWaitBox(0);
		// Missing enemy art leaves enemyArt null (fights then show an empty clip) rather than
		// stopping the dungeon from opening.
		loadArtLibrary(currFileName, pct -> MsgBox.updateWaitBox(pct), function(library) {
			BambaAssets.enemyArt = library;
			loadEnemyAssetsComplete(null);
		});
	}

	function setContinueLoading():Void {
		loadingCounter = 0;
		continueTime = 2000;
		continueLoadingIntervalTimer = new Timer(continueTime);
		continueLoadingIntervalTimer.run = chackContinueLoadingNeeded;
		// continueLoadingInterval = setInterval(chackContinueLoadingNeeded, continueTime);
	}



	function showIOError(error:Dynamic):Void {
		trace("IO Error:" + error);
		//game.errorDT.text = "IOErrorEvent";
	}

	function loadGeneralData():Void {
		trace("loading general data...");
		currFunctionName = "loadGeneralData";
		++loadingCounter;
		Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter]);	
		loadGeneralDataComplete();
	}

	function loadSoundsDataComplete(param1:Event):Void {
		var _loc2_:Xml = null;
		++loadingCounter;
		++msgCounter;
		_loc2_ = Xml.parse(param1.target.data);
		game.sound.loadSoundsStart(_loc2_);
		loadFinished();
	}

	function loadDungeonAssetsComplete(param1:Event):Void {
		++loadingCounter;
		game.finishDungeonAssetLoad();
	}


}
