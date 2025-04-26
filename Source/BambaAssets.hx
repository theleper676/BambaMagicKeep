package;


import tower_screens.*;
import dungeon_graphics.*;
import fight_graphics.*;
import baby.*;
import items.*;
import cards.*;
import menu.MenuScreen;
import new_player.*;
import general_assets.*;
import haxe.Exception;

@:access(swf.exporters.animate)
class BambaAssets {
	public static var cardBase:CardBase;

	public static var help02:Dynamic;

	public static var mapIcon:Dynamic;

	public static var cardsUpgradeScreen:CardsUpgradeScreen;

	public static var help06:Dynamic;

	public static var help01:Dynamic;

	public static var help04:Dynamic;

	public static var help07:Dynamic;

	public static var kingdomMap:Any;

	public static var help03:Dynamic;

	public static var enemyBoss:Any;

	public static var waitBox:WaitBox;

	public static var fightBack:Dynamic;

	public static var help08:Dynamic;

	public static var itemFrame:ItemFrame;

	public static var magicBase:MagicBase;

	public static var help10:Dynamic;

	public static var stickMC:StickMC;

	public static var help05:Dynamic;

	public static var help09:Dynamic;

	public static var hitMatrix:HitMatrix;

	public static var magicBookScreen:MagicBookScreen;

	public static var hitAnim:HitAnim;

	public static var dungeonMap:Dynamic;

	public static var winBox:WinBox;

	public static var dungeonIcon:DungeonIcon;

	public static var hitPoints:HitPoints;

	public static var itemPopup:ItemPopup;

	public static var daiperMC:DaiperMC;

	public static var generalFrame:GeneralFrame;

	public static var newPlayerScreen:NewPlayerScreen;

	public static var hatMC:HatMC;

	public static var babyAttacks:BabyAttacks;

	public static var eyesMC:EyesMC;

	public static var questIcon:QuestIcon;

	public static var cardPopup:CardPopup;

	public static var shoesMC:ShoesMC;

	public static var enemyAttacks:Dynamic;

	public static var questBox:QuestBox;

	public static var msgBox:general_assets.MsgBox;

	public static var skipButton:SkipButton;

	public static var dungeonMain:DungeonMain;

	public static var characterBuildScreen:CharacterBuildScreen;

	public static var fightScreen:FightScreen;

	public static var yesNoBox:YesNoBox;

	public static var levelBox:LevelBox;

	public static var capeMC:CapeMC;

	public static var prizeIcon:PrizeIcon;

	public static var storeScreen:StoreScreen;

	public static var babyMain:BabyMain;

	public static var menuScreen:MenuScreen;

	public static var questManagerScreen:QuestManagerScreen;

	public static var towerScreen:TowerScreen;

	public static var fighterIcon:FighterIcon;

	public static var beltMC:BeltMC;

	public static var openingScreen:OpeningScreen;

	public static var possibleMove:PossibleMove;

	public static var enemyReg:Dynamic;

	public static var enemyTip:EnemyTip;

	public static var characterScreen:CharacterScreen;

	public static var hairMC:HairMC;

	public static var emptyCard:Dynamic;

	public var game:BambaMain;

	public function new(mainGame:BambaMain) {
		game = mainGame;
	}

	function define_characterScreen():Void {
		characterScreen = new CharacterScreen();
		/* if(Std.is(param1, Dynamic))
			characterScreen = param1;
		characterScreen = cast(param1, BambaCharacterScreen); */
	}

	function define_hairMC():Void {
		hairMC = new HairMC();
		//hairMC = cast(param1, MovieClip);
	}

	function define_cardBase():Void  {
		cardBase = new CardBase();
		//cardBase = cast(param1, BambaCard);
	}

	function define_help01(param1:Dynamic):Void  {
		help01 = param1;
		//help01 = cast(param1, Dynamic);
	}

	function define_help03(param1:Dynamic):Void  {
		help03 = param1;
		//help03 = cast(param1, Dynamic);
	}

	function define_cardsUpgradeScreen():Void  {
		cardsUpgradeScreen = new CardsUpgradeScreen();
		//cardsUpgradeScreen = cast(param1, Dynamic);
	}

	function define_help05(param1:Dynamic):Void  {
		help05 = param1;
		//help05 = cast(param1, BambaHelp);
	}

	function define_help06(param1:Dynamic):Void  {
		help06 = param1;
		//help06 = cast(param1, BambaHelp);
	}

	function define_help07(param1:Dynamic):Void  {
		help07 = param1;
		//help07 = cast(param1, BambaHelp);
	}

	function define_questBox():Void  {
		questBox = new QuestBox();
		// questBox = cast(param1, BambaQuest);
	}

	function define_msgBox():Void  {
		msgBox = new MsgBox();
		//msgBox = new MsgBox();
		/* msgBox = param1;
		msgBox = cast(param1, MsgBox); */
	}

	function define_help04(param1:Dynamic):Void  {
		help04 = param1;
		//help04 = cast(param1, BambaHelp);
	}

	function define_enemyBoss(param1:Dynamic):Void  {
		enemyBoss = param1;
		//enemyBoss = cast(param1, Dynamic);
	}

	function define_waitBox():Void  {
		waitBox = new WaitBox();
	}

	function define_mapIcon(param1:Dynamic):Void  {
		mapIcon = param1;
		//mapIcon = cast(param1, Dynamic);
	}

	function define_help08(param1:Dynamic):Void  {
		help08 = param1;
		//help08 = cast(param1, BambaHelp);
	}

	function define_skipButton():Void  {
		skipButton = new SkipButton();
		//skipButton = cast(param1, Dynamic);
	}

	function define_itemFrame():Void  {
		itemFrame = new ItemFrame();
		// itemFrame = cast(param1, Dynamic);
	}

	function define_fightScreen():Void  {
		fightScreen =  new FightScreen();
		//fightScreen = cast(param1, Dynamic);
	}

	function define_magicBase():Void  {
		magicBase = new MagicBase();
		//magicBase = cast(param1, BambaItem);
	}

	function define_characterBuildScreen():Void {
		characterBuildScreen = new CharacterBuildScreen();
		//characterBuildScreen = cast(param1, Dynamic);
	}

	function define_help09(param1:Dynamic):Void {
		help09 = param1;
		//help09 = cast(param1, Dynamic);
	}

	function define_dungeonMain():Void  {
		dungeonMain = new DungeonMain();
		//dungeonMain = cast(param1, Dynamic);
	}

	function define_help02(param1:Dynamic):Void  {
		help02 = param1;
		// help02 = cast(param1, Dynamic);
	}

	function define_stickMC():Void  {
		stickMC = new StickMC();
		//stickMC = cast(param1, Dynamic);
	}

	function define_kingdomMap(param1:Dynamic):Void  {
		kingdomMap = param1;
		//kingdomMap = cast(param1, Dynamic);
	}

	function define_prizeIcon():Void  {
		prizeIcon = new PrizeIcon();
		//prizeIcon = cast(param1, Dynamic);
	}

	function define_storeScreen():Void  {
		storeScreen = new StoreScreen();
		//storeScreen = cast(param1, Dynamic);
	}

	function define_levelBox():Void  {
		levelBox = new LevelBox();
		// levelBox = cast(param1, Dynamic);
	}

	function define_capeMC():Void {
		capeMC = new CapeMC();
		//capeMC = cast(param1,MovieClip);
	}

	function define_yesNoBox():Void  {
		yesNoBox = new YesNoBox();
		//yesNoBox = cast(param1, Dynamic);
	}

	function define_menuScreen():Void  {
		menuScreen = new MenuScreen();
		// menuScreen = cast(param1, Dynamic);
	}

	function define_hitMatrix():Void  {
		hitMatrix = new HitMatrix();
		//hitMatrix = cast(param1, Dynamic);
	}

	function define_babyMain():Void  {
		babyMain= new BabyMain();
		//babyMain = cast(param1, Dynamic);
	}

	function define_enemyAttacks(param1:Dynamic):Void  {
		enemyAttacks = param1;
		//enemyAttacks = cast(param1, Dynamic);
	}

	function define_fightBack(param1:Dynamic):Void  {
		fightBack = param1;
		// fightBack = cast(param1, Dynamic);
	}

	function define_questManagerScreen():Void  {
		questManagerScreen = new QuestManagerScreen();
		//questManagerScreen = cast(param1, Dynamic);
	}

	function define_help10(param1:Dynamic):Void  {
		help10 = param1;
		//help10 = cast(param1, Dynamic);
	}

	function define_magicBookScreen():Void  {
		magicBookScreen = new MagicBookScreen();
		//magicBookScreen = cast(param1, Dynamic);
	}

	function define_hitAnim():Void  {
		hitAnim = new HitAnim();
		//hitAnim = cast(param1, Dynamic);
	}

	function define_dungeonMap(param1:Dynamic):Void  {
		dungeonMap = param1;
		//dungeonMap = cast(param1, Dynamic);
	}

	function define_dungeonIcon():Void  {
		dungeonIcon = new DungeonIcon();
		//dungeonIcon = cast(param1, Dynamic);
	}

	function define_towerScreen():Void  {
		towerScreen = new TowerScreen();
		// towerScreen = cast(param1, Dynamic);
	}

	function define_fighterIcon():Void  {
		fighterIcon = new FighterIcon();
		//fighterIcon = cast(param1, Dynamic);
	}

	function define_winBox():Void  {
		winBox = new WinBox();
		// winBox = cast(param1, Dynamic);
	}

	function define_itemPopup():Void  {
		itemPopup = new ItemPopup();
		// itemPopup = cast(param1, Dynamic);
	}

	function define_hitPoints():Void  {
		hitPoints = new HitPoints();
		// hitPoints = cast(param1, Dynamic);
	}

	function define_openingScreen():Void  {
		openingScreen = new OpeningScreen();
		/* var libraryPath = Assets.getPath("openingAssets");
		AnimateLibrary.loadFromFile(libraryPath); */
	}

	function define_beltMC():Void {
		beltMC = new BeltMC();
		// beltMC = cast(param1, MovieClip);
	}

	function define_possibleMove():Void  {
		possibleMove = new PossibleMove();
		// possibleMove = cast(param1, Dynamic);
	}

	function define_newPlayerScreen():Void  {
		newPlayerScreen = new NewPlayerScreen();
		// newPlayerScreen = cast(param1, MovieClip);
	}

	function define_daiperMC():Void  {
		daiperMC = new DaiperMC();
		//daiperMC = cast(param1, Dynamic);
	}

	function define_hatMC():Void {
		hatMC = new HatMC();
		// hatMC = cast(param1, MovieClip);
	}

	function define_generalFrame():Void  {
		generalFrame = new GeneralFrame();
		// generalFrame = cast(param1, Dynamic);
	}

	function define_babyAttacks():Void  {
		babyAttacks = new BabyAttacks();
		// babyAttacks = cast(param1, Dynamic);
	}

	/**
	 * Needed to write a new function to check if a function in define exists
	 * and to call it with the class itself
	 * @param instace 
	 * @param instanceClass  
	 */
	public function defineAsset<T>(instance:String):Void {
		var functionName:String = "define_" + instance;
		var method = Reflect.field(this, functionName);

		try {
			if(method != null && Reflect.isFunction(method)) {
				Reflect.callMethod(this,method, []);
				//Reflect.callMethod(this, method, [param2]);
			}
		} catch(error) {
			trace("function define error" + error);
		}
	}

	function define_questIcon():Void  {
		questIcon = new QuestIcon();
		//questIcon = cast(param1, MovieClip);
	}

	function define_cardPopup():Void  {
		cardPopup = new CardPopup();
		// cardPopup = cast(param1, MovieClip);
	}

	function define_emptyCard(param1:Dynamic):Void  {
		emptyCard = param1;
		// emptyCard = cast(param1, BambaCard);
	}

	function define_shoesMC():Void  {
		shoesMC = new ShoesMC();
		// shoesMC = cast(param1, MovieClip);
	}

	function define_eyesMC():Void  {
		eyesMC = new EyesMC();
		// eyesMC = cast(param1, MovieClip);
	}

	function define_enemyTip():Void  {
		enemyTip = new EnemyTip();
		// enemyTip = cast(param1, MovieClip);
	}

	function define_enemyReg(param1:Dynamic):Void  {
		enemyReg = param1;
		// enemyReg = cast(param1, MovieClip);
	}
}
