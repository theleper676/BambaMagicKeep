package;

import haxe.ui.Toolkit;
import dungeon_graphics.DungeonMain;
import general_assets.GeneralFrame;
import haxe.Timer;
import erate.ERate;
import openfl.display.*;
import openfl.net.SharedObject;
import openfl.events.*;
import general.ButtonUpdater;
import general.Heb;
import general.MsgBox;
import general.PlayerDataUpdater;

class BambaMain extends Sprite{
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
		
		if(this.stage != null) {
			init();
		}
	}

	private function init() {
		stage.scaleMode = StageScaleMode.EXACT_FIT;
		//this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
        //stage.align = StageAlign.TOP_LEFT;
		//fitToStage();
	}

	private function fitToStage () {
		var originalWidth = this.width / this.scaleX;
		var originalHeight = this.height / this.scaleY;

		var scaleX = stage.stageWidth / originalWidth;
		var scaleY = stage.stageHeight / originalHeight;
		var scaleFactor = Math.max(scaleX, scaleY);
		this.scaleX = this.scaleY = scaleFactor;
		trace(scaleX);
		this.x = (stage.stageWidth / this.width) / 2;
		this.y = (stage.stageHeight / this.height) / 2;
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

	public function showMovie(param1:Dynamic):Void {
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
		soundTimer.stop();
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
		soundTimer.stop();
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

	public function endMovie(param1:Dynamic):Void {
		this.removeChild(param1);
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
		if (Math.isNaN(currEnemyId)) {
			finishEnemyAssetLoad();
		} else {
			_loc2_ = gameData.getCatalogEnemy(currEnemyId, 1);
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

	public function centerScreen(param1:Dynamic):Void {
		if (frameMC != null) {
			this.setChildIndex(frameMC, this.numChildren - 1);
		}
		if (param1.orgWidth == null) {
			param1.x = (945 - param1.width) / 2;
			param1.y = (650 - param1.height) / 2;
		} else {
			param1.x = (945 - param1.orgWidth) / 2;
			param1.y = (650 - param1.orgHeight) / 2;
		}
	}

	public function cornerScreen(param1:Dynamic):Void {
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
			if (gameData.playerData.pName == "") {
				startNewPlayer();
			} else {
				addFrame();
				MsgBox.init(this);
				PlayerDataUpdater.init(this);
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
