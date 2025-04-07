package;

import openfl.Assets;
import haxe.xml.Access;
import sys.io.File;
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

	private var dungeonAssetsNames:String;

	var loadingMsgs:Array<Dynamic>;

	var fileSizes:Array<Dynamic>;

	var xmlFunctionNames:Array<String>;

	var continueLoadingIntervalTimer: Timer = null;
	//var continueLoadingInterval:Float;

	var currFileName:String;

	var assets:Array<Dynamic>;

	var totalBytes:Float;

	public var soundsPath:String;

	private var soundsFileName:String;

	var xmlFiles:Array<String>;

	private var paramFile:String = "params.xml";

	var tempMail:String;

	public var currFunctionName:String;

	private var xmlPath:String;

	private var dictionaryFileName:String;

	var currAsset:Array<Dynamic>;

	var currLoadXMLFunctionName:String;

	private var enemyAssetsNames:String;

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

	static inline function extractAssetElements (root:Access, nodeName:String):Array<String> {
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
		var tempCurrAssetString:Null<Dynamic>;
		var loader:Loader;
		var request:URLRequest;
		currFunctionName = "loadAssets";
		++loadingCounter;
		if (assetsIndex < assets.length) {
			tempCurrAssetString = assets[assetsIndex];
			currAsset = tempCurrAssetString.split(",");
			try {
				ExternalInterface.call("console.log", {
					"fb_msgCounter": msgCounter,
					"fb_currAsset": currAsset[0]
				});
			} catch (error:Dynamic) {}
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
		}
	}

	function loadPlayerDataComplete(param1:Event):Void {
		var _loc2_:Xml = null;
		_loc2_ = Xml.parse(param1.target.data);
		var errorCode = Std.parseInt(_loc2_.get("errorCode"));
		if ( errorCode != null && errorCode == 0) {
			game.innerCount(14);
			game.gameData.loadPlayerData(_loc2_);
			game.finishLoadPlayerData();
		} else {
			game.opening.showErrorMsg(errorCode);
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
		var _loc2_:Int = 1;
		var _loc3_:String;
		while (_loc2_ < openingAssets.length) {
			_loc3_ = openingAssets[_loc2_];
			game.gameAssets.defineAsset(_loc3_, OpeningScreen);
			_loc2_++;
		};
		haxe.Timer.delay(game.showOpeningScreen, 3000);
		haxe.Timer.delay(loadDictionary, 3500);	
	}

	function loadDictionary():Void {
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

	public function sendNewPlayerData(param1:Dynamic, param2:Dynamic, param3:Dynamic, param4:Dynamic):Void {
		var _loc5_:URLRequest = null;
		var _loc6_:URLLoader = null;
		var _loc7_:URLVariables = null;
		game.gameData.playerData.setUserPass(param1, param2);
		_loc5_ = new URLRequest(newPlayerDataSource);
		if (_loc5_.url != "xmls/newPlayerAnswer.xml") {
			(_loc7_ = new URLVariables()).PlayerName = param1;
			_loc7_.Password = param2;
			_loc7_.Mail = param3;
			_loc7_.Age = param4;
			_loc7_.dummy = Std.string(Math.random());
			//_loc7_.dummy = Std.string(getTimer()) + Std.string(Math.random());
			_loc5_.data = _loc7_;
		}
		_loc6_ = new URLLoader();
		_loc6_.addEventListener(Event.COMPLETE, sendNewPlayerDataComplete, false, 0, true);
		_loc6_.load(_loc5_);
		MsgBox.showWaitBox("יוצר משתמש חדש");
	}

	function loadGeneralDataComplete(param1:Event):Void {
		var _loc2_:Xml = null;
		currBytes += Std.parseFloat(fileSizes[msgCounter]);
		setLoaderGraphics(currBytes / totalBytes);
		++msgCounter;
		++loadingCounter;
		_loc2_ = Xml.parse(param1.target.data);
		game.gameData.loadGeneralData(_loc2_);
		loadXMLFile();
	}

	function loadAssetsProgress(param1:ProgressEvent):Void {
		var _loc2_:Float = Math.NaN;
		var _loc3_:Float = Math.NaN;
		_loc2_ = param1.bytesLoaded / param1.bytesTotal;
		_loc3_ = Math.floor(_loc2_ * 100);
		Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter] + " %" + _loc3_);
		setLoaderGraphics((currBytes + _loc2_ * Std.parseFloat(fileSizes[msgCounter])) / totalBytes);
		++loadingCounter;
	}

	public function loadDungeonAsset():Void {
		var _loc1_:Loader = null;
		var _loc2_:URLRequest = null;
		currFunctionName = "loadDungeonAsset";
		++loadingCounter;
		_loc1_ = new Loader();
		_loc2_ = new URLRequest(assetsPath + "/" + currFileName);
		_loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE, loadDungeonAssetsComplete, false, 0, true);
		_loc1_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadDungeonAssetsProgress, false, 0, true);
		_loc1_.load(_loc2_);
		currLoader = _loc1_;
		MsgBox.showWaitBox(game.gameData.dictionary.LOADING_DUNGEON_MSG);
	}

	public function loadEnemyAssetStart(param1:Dynamic):Void {
		currFileName = param1;
		loadEnemyAsset();
	}

	function loadAssetsComplete(param1:Event):Void {
		var _loc2_:Null<Dynamic> = null;
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
		++assetsIndex;
		loadAssets();
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
		_playerLevelsFileName = node.playerlevelsfilename.innerData;
		_magicBookFileName = node.magicbookfilename.innerData;
		_cardsFileName = node.cardsfilename.innerData;
		_enemiesFileName = node.enemiesfilename.innerData;
		_enemiesLevelsFileName = node.enemieslevelsfilename.innerData;
		_itemsBaseFileName = node.itemsbasefilename.innerData;
		_itemsFileName = node.itemsfilename.innerData;
		_storeItemsFileName = node.storeitemsfilename.innerData;
		_prizesFileName = node.prizesfilename.innerData;
		_surprisesFileName = node.surprisesfilename.innerData;
		_dungeonsDataFileName = node.dungeonsdatafilename.innerData;
		_questsFileName = node.questsfilename.innerData;
		_helpFileName = node.helpfilename.innerData;

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
		dungeonAssetsNames =  "dugeonname,dugeonname2";//_loc2_.dungeonAssetsNames;
		enemyAssetsNames = "enemyassset1, enemyasset2";
		loadOpeningAssets();
		var introPath = Assets.getPath("IntroBamba");
		game.movie.setMovieAsset(introPath);	
	}

	public function loadDungeonAssetStart(param1:Dynamic):Void {
		currFileName = param1;
		setContinueLoading();
		loadDungeonAsset();
	}

	function loadXMLFile():Void {
		var request:URLRequest = null;
		var loader:URLLoader = null;
		currFunctionName = "loadXMLFile";
		++loadingCounter;
		if (xmlFilesIndex < xmlFiles.length) {
			currFileName = xmlFiles[xmlFilesIndex];
			Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter]);
			try {
				ExternalInterface.call("console.log", {
					"fb_msgCounter": msgCounter,
					"fb_currFileName": currFileName
				});
			} catch (error:Dynamic) {}
			currLoadXMLFunctionName = xmlFunctionNames[xmlFilesIndex];
			request = new URLRequest(xmlPath + "/" + currFileName);
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, loadXMLComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, showIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, showSecurityError);
			currLoader = loader;
			try {
				loader.load(request);
			} catch (error:Dynamic) {
				trace("XML load error: " + error.message);
				//game.errorDT.text = error.errorID + ":" + error.name + ":" + error.message;
			}
		} else {
			loadAssets();
		}
	}

	function loadDictionaryComplete(dictionaryXml:Xml):Void {
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
		continueLoadingIntervalTimer.stop();
		// clearInterval(continueLoadingInterval);
	}

	public function savePlayerData():Void {
		var _loc1_:URLRequest = null;
		var _loc2_:URLVariables = null;
		var _loc3_:URLLoader = null;
		_loc1_ = new URLRequest(updatePlayerDataSource);
		_loc2_ = new URLVariables();
		_loc2_.PN = game.gameData.playerData.user;
		_loc2_.PW = game.gameData.playerData.pass;
		_loc2_.NN = game.gameData.playerData.pName;
		_loc2_.PL = game.gameData.playerData.level;
		_loc2_.OC = game.gameData.playerData.orderCode;
		_loc2_.MA = game.gameData.playerData.magic.toString();
		_loc2_.CA = game.gameData.playerData.cards.toString();
		_loc2_.EP = game.gameData.playerData.exPoints;
		_loc2_.IT = game.gameData.playerData.items.toString();
		_loc2_.MO = game.gameData.playerData.money;
		_loc2_.I1 = game.gameData.playerData.ingredient1;
		_loc2_.I2 = game.gameData.playerData.ingredient2;
		_loc2_.I3 = game.gameData.playerData.ingredient3;
		_loc2_.I4 = game.gameData.playerData.ingredient4;
		_loc2_.IIU = game.gameData.playerData.itemsInUse.toString();
		_loc2_.CQI = game.gameData.playerData.currentQuestId;
		_loc2_.PQI = game.gameData.playerData.pastQuestsIds.toString();
		_loc2_.PDI = game.gameData.playerData.pastDungeonsIds.toString();
		_loc2_.dummy = Std.string(Math.random());
		if (_loc1_.url != "local") {
			_loc1_.data = _loc2_;
			_loc3_ = new URLLoader();
			_loc3_.addEventListener(Event.COMPLETE, savePlayerDataComplete, false, 0, true);
			_loc3_.load(_loc1_);
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
		try {
			ExternalInterface.call("console.log", {
				"fb_loadingCounter": loadingCounter,
				"fb_functionName": currFunctionName
			});
		} catch (error:Dynamic) {}
		trace("BambaLoader.continueLoading:" + currFunctionName);
		continueLoadingIntervalTimer.stop();
		var arrayAccess:Function = Reflect.field(this, currCompleteFunctionName);
		currCompleteFunctionName = currFunctionName + "Complete";
		currLoader.removeEventListener(Event.COMPLETE, arrayAccess());
		continueTime += 500;
		continueLoadingIntervalTimer = new Timer(continueTime);
		continueLoadingIntervalTimer.run = chackContinueLoadingNeeded;
		// continueLoadingInterval = setInterval(chackContinueLoadingNeeded, continueTime);
		arrayAccess();
	}

	function sendNewPlayerDataComplete(param1:Event):Void {
		var _loc2_:Xml = null;
		_loc2_ = Xml.parse(param1.target.data);
		var errorCode:String = _loc2_.get("errorCode");
		trace("2 sendNewPlayerDataComplete:" + _loc2_);
		MsgBox.closeWaitBox();
		if (errorCode == "0") {
			trace("sendNewPlayerDataComplete:A OK");
			game.showCharacterBuildAfterNewPlayer();
		} else {
			switch (Std.parseInt(errorCode)) {
				case 1:
					MsgBox.show(game.gameData.dictionary.NEW_PLAYER_NAME_EXISTING);
				case 2:
					MsgBox.show(game.gameData.dictionary.NEW_PLAYER_ILLEGAL_MAIL);
				case 3:
					MsgBox.show(game.gameData.dictionary.NEW_PLAYER_MAIL_EXISTING);
			}
		}
	}

	public function forgetPass(param1:Dynamic):Void {
		var _loc2_:URLRequest = null;
		var _loc3_:URLVariables = null;
		var _loc4_:URLLoader = null;
		tempMail = param1;
		_loc2_ = new URLRequest(forgetPassSource);
		_loc3_ = new URLVariables();
		_loc3_.Mail = param1;
		_loc3_.dummy = Std.string(Math.random());
		if (_loc2_.url != "local") {
			_loc2_.data = _loc3_;
			_loc4_ = new URLLoader();
			_loc4_.addEventListener(Event.COMPLETE, forgetPassComplete, false, 0, true);
			_loc4_.load(_loc2_);
		} else {
			game.opening.showPassSendMsg();
		}
	}

	function loadXMLComplete(param1:Event):Void {
		var _loc2_:Null<Dynamic> = null;
		var gameDataAccessFunction:Function = Reflect.field(game.gameData,currLoadXMLFunctionName);
		++loadingCounter;
		currBytes += Std.parseFloat(fileSizes[msgCounter]);
		setLoaderGraphics(currBytes / totalBytes);
		++msgCounter;
		_loc2_ = Xml.parse(param1.target.data);
		gameDataAccessFunction(_loc2_.children());
		++xmlFilesIndex;
		loadXMLFile();
	}

	function loadOpeningAssets():Void {
		//var _loc1_:Loader = null;
		//var _loc2_:URLRequest;
		//currFunctionName = "loadOpeningAssets";
		//_loc1_ = new Loader();
		//_loc2_  = new URLRequest(Assets.getPath("OpeningAssets"));
		//_loc2_ = //new URLRequest(assetsPath + "/" + openingAssets[0]);
		//_loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE, loadOpeningAssetsComplete, false, 0, true);
		//currLoader = _loc1_;
		//_loc1_.load(_loc2_); 
		loadOpeningAssetsComplete();
	}

	function loadEnemyAssetsComplete(param1:Event):Void {
		var _loc2_:Array<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		++loadingCounter;
		_loc2_ = enemyAssetsNames.split(",");
		_loc3_ = 0;
		while (_loc3_ < _loc2_.length) {
			_loc4_ = _loc2_[_loc3_];
			game.gameAssets.defineAsset(_loc4_, BambaMain);
			_loc3_++;
		}
		finishContinueLoading();
		game.finishEnemyAssetLoad();
	}

	function setLoaderGraphics(param1:Float):Void {
		game.opening.mc.loadingBarMC.flareMC.x = 800 - 800 * param1;
		game.opening.mc.loadingBarMC.maskMC.width = 800 * param1;
		game.opening.mc.loadingBarMC.maskMC.x = 800 - 800 * param1;
	}

	function showSecurityError(error:SecurityErrorEvent):Void {
		trace("security error:" + error.target.toString() );
		//game.errorDT.text = "SecurityErrorEvent";
	}

	public function loadPlayerData(param1:Dynamic, param2:Dynamic):Void {
		var _loc3_:URLRequest = null;
		var _loc4_:URLLoader = null;
		var _loc5_:URLVariables = null;
		game.gameData.playerData.setUserPass(param1, param2);
		_loc3_ = new URLRequest(playerDataSource);
		if (_loc3_.url != "xmls/playerData.xml") {
			(_loc5_ = new URLVariables()).PlayerName = param1;
			_loc5_.Password = param2;
			_loc5_.dummy = Std.string(Math.random()) ;
			_loc3_.data = _loc5_;
		}
		_loc4_ = new URLLoader();
		_loc4_.addEventListener(Event.COMPLETE, loadPlayerDataComplete, false, 0, true);
		_loc4_.load(_loc3_);
	}

	public function loadEnemyAsset():Void {
		var _loc1_:Loader = null;
		var _loc2_:URLRequest = null;
		currFunctionName = "loadEnemyAsset";
		++loadingCounter;
		_loc1_ = new Loader();
		_loc2_ = new URLRequest(assetsPath + "/" + currFileName);
		_loc1_.contentLoaderInfo.addEventListener(Event.COMPLETE, loadEnemyAssetsComplete, false, 0, true);
		MsgBox.updateWaitBoxTxt(game.gameData.dictionary.LOADING_ENEMY_MSG);
		MsgBox.updateWaitBox(0);
		_loc1_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loadEnemyAssetsProgress, false, 0, true);
		_loc1_.load(_loc2_);
		currLoader = _loc1_;
	}

	function setContinueLoading():Void {
		loadingCounter = 0;
		continueTime = 2000;
		continueLoadingIntervalTimer = new Timer(continueTime);
		continueLoadingIntervalTimer.run = chackContinueLoadingNeeded;
		// continueLoadingInterval = setInterval(chackContinueLoadingNeeded, continueTime);
	}

	function loadEnemyAssetsProgress(param1:ProgressEvent):Void {
		var _loc2_:Float = Math.NaN;
		_loc2_ = Math.floor(param1.bytesLoaded / param1.bytesTotal * 100);
		++loadingCounter;
		MsgBox.updateWaitBox(_loc2_);
	}

	function savePlayerDataComplete(param1:Event):Void {
		var _loc2_:Xml = null;
		_loc2_ = Xml.parse(param1.target.data);
		var errorCode:Int = Std.parseInt(_loc2_.get("errorCode"));
		var message:String = _loc2_.get("msg");
		trace("3 savePlayerDataComplete:" + _loc2_);
		if (errorCode == 0) {
			trace("savePlayerDataComplete:A OK");
		} else {
			MsgBox.show(message);
		}
	}

	function showIOError(error:IOErrorEvent):Void {
		trace("IO Error:" + error.target.toString());
		//game.errorDT.text = "IOErrorEvent";
	}

	function loadGeneralData():Void {
		trace("loading general data...");
		/* var _loc1_:URLRequest = null;
		var _loc2_:URLLoader = null;
		currFunctionName = "loadGeneralData";
		++loadingCounter;
		Heb.setText(game.opening.mc.loadingBarMC.loaderDT, loadingMsgs[msgCounter]);
		_loc1_ = new URLRequest(xmlPath + "/" + generalDataFileName);
		_loc2_ = new URLLoader();
		_loc2_.addEventListener(Event.COMPLETE, loadGeneralDataComplete, false, 0, true);
		currLoader = _loc2_;
		_loc2_.load(_loc1_); */
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
		var _loc2_:Array<String> = null;
		var _loc3_:Null<Dynamic> = null; 
		var _loc4_:Null<Dynamic> = null; 
		++loadingCounter;
		_loc2_ = dungeonAssetsNames.split(",");
		_loc3_ = 0;
		while (_loc3_ < _loc2_.length) {
			_loc4_ = _loc2_[_loc3_];
			game.gameAssets.defineAsset(_loc4_, BambaMain);
			_loc3_++;
		}
		game.finishDungeonAssetLoad();
	}

	function forgetPassComplete(param1:Event):Void {
		var _loc2_:Xml = null;
		var _loc3_:URLRequest = null;
		var _loc4_:URLVariables = null;
		var _loc5_:URLLoader = null;
		_loc2_ = Xml.parse(param1.target.data);
		var errorCode:Int = Std.parseInt(_loc2_.get("errorCode"));
		var playerName:String = _loc2_.get("playerName");
		var password:String = _loc2_.get("password");
		trace("forgetPassComplete:" + _loc2_);
		trace("forgetPassComplete:" + sendPassSource + ":" + tempMail);
		if (errorCode == 0) {
			_loc3_ = new URLRequest(sendPassSource);
			(_loc4_ = new URLVariables()).email = tempMail;
			_loc4_.user = playerName;
			_loc4_.pass = password;
			_loc4_.dummy = Std.string(Lib.getTimer()) + Std.string(Math.random());
			_loc3_.data = _loc4_;
			_loc5_ = new URLLoader();
			_loc5_.load(_loc3_);
			game.opening.showPassSendMsg();
		} else {
			game.opening.showForgetPassErrorMsg(errorCode);
		}
	}

	function loadDungeonAssetsProgress(param1:ProgressEvent):Void {
		var _loc2_:Float = Math.NaN;
		_loc2_ = Math.floor(param1.bytesLoaded / param1.bytesTotal * 100);
		++loadingCounter;
		MsgBox.updateWaitBox(_loc2_);
	}
}
