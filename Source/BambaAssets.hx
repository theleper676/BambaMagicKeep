package;


import baby.BabyMain;
import items.ItemPopup;
import items.ItemFrame;
import items.HairMC;
import items.BeltMC;
import items.ShoesMC;
import items.EyesMC;
import items.DaiperMC;
import items.CapeMC;
import items.HatMC;
import items.StickMC;
import cards.CardBase;
import cards.MagicBase;
import menu.MenuScreen;
import cards.CardPopup;
import new_player.CharacterBuildScreen;
import new_player.NewPlayerScreen;
import general_assets.QuestBox;
import general_assets.*;
import haxe.Exception;
import openfl.display.MovieClip;

@:access(swf.exporters.animate)
class BambaAssets {
	public static var cardBase:CardBase;

	public static var help02:Dynamic;

	public static var mapIcon:Dynamic;

	public static var cardsUpgradeScreen:Dynamic;

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

	public static var hitMatrix:Any;

	public static var magicBookScreen:Dynamic;

	public static var hitAnim:Dynamic;

	public static var dungeonMap:Dynamic;

	public static var winBox:WinBox;

	public static var dungeonIcon:Dynamic;

	public static var hitPoints:Dynamic;

	public static var itemPopup:ItemPopup;

	public static var daiperMC:DaiperMC;

	public static var generalFrame:GeneralFrame;

	public static var newPlayerScreen:NewPlayerScreen;

	public static var hatMC:HatMC;

	public static var babyAttacks:Dynamic;

	public static var eyesMC:EyesMC;

	public static var questIcon:QuestIcon;

	public static var cardPopup:CardPopup;

	public static var shoesMC:ShoesMC;

	public static var enemyAttacks:Dynamic;

	public static var questBox:QuestBox;

	public static var msgBox:general_assets.MsgBox;

	public static var skipButton:SkipButton;

	public static var dungeonMain:Dynamic;

	public static var characterBuildScreen:CharacterBuildScreen;

	public static var fightScreen:Dynamic;

	public static var yesNoBox:YesNoBox;

	public static var levelBox:LevelBox;

	public static var capeMC:CapeMC;

	public static var prizeIcon:PrizeIcon;

	public static var storeScreen:Dynamic;

	public static var babyMain:BabyMain;

	public static var menuScreen:MenuScreen;

	public static var questManagerScreen:Dynamic;

	public static var towerScreen:Dynamic;

	public static var fighterIcon:Dynamic;

	public static var beltMC:BeltMC;

	public static var openingScreen:OpeningScreen;

	public static var possibleMove:Dynamic;

	public static var enemyReg:Dynamic;

	public static var enemyTip:Dynamic;

	public static var characterScreen:Dynamic;

	public static var hairMC:HairMC;

	public static var emptyCard:Dynamic;

	public var game:BambaMain;

	public function new(mainGame:BambaMain) {
		game = mainGame;
	}

	function define_characterScreen(param1:Dynamic):Void {
		characterScreen = param1;
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

	function define_cardsUpgradeScreen(param1:Dynamic):Void  {
		cardsUpgradeScreen = param1;
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

	function define_fightScreen(param1:Dynamic):Void  {
		fightScreen = param1;
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

	function define_dungeonMain(param1:Dynamic):Void  {
		dungeonMain = param1;
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

	function define_storeScreen(param1:Dynamic):Void  {
		storeScreen = param1;
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

	function define_hitMatrix(param1:Dynamic):Void  {
		hitMatrix = param1;
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

	function define_questManagerScreen(param1:Dynamic):Void  {
		questManagerScreen = param1;
		//questManagerScreen = cast(param1, Dynamic);
	}

	function define_help10(param1:Dynamic):Void  {
		help10 = param1;
		//help10 = cast(param1, Dynamic);
	}

	function define_magicBookScreen(param1:Dynamic):Void  {
		magicBookScreen = param1;
		//magicBookScreen = cast(param1, Dynamic);
	}

	function define_hitAnim(param1:Dynamic):Void  {
		hitAnim = param1;
		//hitAnim = cast(param1, Dynamic);
	}

	function define_dungeonMap(param1:Dynamic):Void  {
		dungeonMap = param1;
		//dungeonMap = cast(param1, Dynamic);
	}

	function define_dungeonIcon(param1:Dynamic):Void  {
		dungeonIcon = param1;
		//dungeonIcon = cast(param1, Dynamic);
	}

	function define_towerScreen(param1:Dynamic):Void  {
		towerScreen = param1;
		// towerScreen = cast(param1, Dynamic);
	}

	function define_fighterIcon(param1:Dynamic):Void  {
		fighterIcon = param1;
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

	function define_hitPoints(param1:Dynamic):Void  {
		hitPoints = param1;
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

	function define_possibleMove(param1:Dynamic):Void  {
		possibleMove = param1;
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

	function define_babyAttacks(param1:Dynamic):Void  {
		babyAttacks = param1;
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

	function define_enemyTip(param1:Dynamic):Void  {
		enemyTip = param1;
		// enemyTip = cast(param1, MovieClip);
	}

	function define_enemyReg(param1:Dynamic):Void  {
		enemyReg = param1;
		// enemyReg = cast(param1, MovieClip);
	}
}
