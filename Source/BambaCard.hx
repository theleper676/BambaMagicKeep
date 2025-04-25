package;

import cards.*;
import flash.display.*;
import flash.events.MouseEvent;
import flash.geom.ColorTransform;
import flash.text.TextFormat;
import general.Heb;


class BambaCard {
	public var ingredient1:Float;

	public var ingredient4:Float;

	public var magicAnimDepth:Float;

	public var attackString:String;

	public var magicAnimName:String;

	public var disabled:Bool;

	public var cName:String;

	public var ingredient3:Float;

	public var cDesc:String;

	public var sound:String;

	public var fight:Dynamic;

	public var id:Float;

	public var mc:CardBase;

	public var game:BambaMain;

	public var regenerateAmount:Float;

	public var picked:Bool;

	public var ingredient2:Float;

	public var ponAnimName:String;

	public var magicId:Float;

	public var upgradeTo:Float;

	public var defenseAmount:Float;

	public var graphicsName:String;

	public var upgradeLevel:String;

	public var fixedLocation:Array<Int>;

	public var cost:Float;

	public var popupMC:CardPopup;

	public var minLevel:Float;

	public var upgradeDesc:String;

	public var animLength:Float;

	public var healAmount:Float;

	public var data:{upgradeto:Int, upgradelevel:String, upgradedesc:String, regenerateamount:Int, ponanimname:String, name:String, movedir:Int, minlevel:Int, magicid:Int, ingredient4:Int, ingredient3:Int, ingredient2:Int, ingredient1:Int, id:Int, healamount:Int, graphicsname:String, desc:String, defenseamount:Int, damage:Int, cost:Int, animlength:Float, animdelay:Float};

	public var color:Int;

	public var damage:Float;

	public var animDelay:Float;

	public var screen:BambaUpgradeSystem;

	public var orgX:Float;

	public var orgY:Float;

	public var moveDir:Float;

	public function new(card:{upgradeto:Int, upgradelevel:String, upgradedesc:String, regenerateamount:Int, ponanimname:String, name:String, movedir:Int, minlevel:Int, magicid:Int, ingredient4:Int, ingredient3:Int, ingredient2:Int, ingredient1:Int, id:Int, healamount:Int, graphicsname:String, desc:String, defenseamount:Int, damage:Int, cost:Int, animlength:Float, animdelay:Float}) {
		this.data = card;
		this.id = card.id;
		this.cName = card.name;
		//cName = param1.name;
		this.upgradeLevel = card.upgradelevel;
		this.graphicsName = card.graphicsname;
		//graphicsName = param1.graphicsName;
		this.cDesc = card.desc;
		this.cost = card.cost;
		this.damage = card.damage;
		this.moveDir = card.movedir;
		this.attackString = "";
		this.defenseAmount = card.defenseamount;
		this.regenerateAmount = card.regenerateamount;
		this.healAmount = card.healamount;
		this.magicId = card.magicid;
		this.color = 1;
		this.ponAnimName = card.ponanimname;
		this.magicAnimName = "";
		this.animLength = card.animlength;
		this.animDelay = card.animdelay;
		this.magicAnimDepth = 1.0;
		this.sound = "";
		this.fixedLocation = [];
		this.upgradeTo = card.upgradeto;
		this.upgradeDesc = card.upgradedesc;
		this.ingredient1 = card.ingredient1;
		this.ingredient2 = card.ingredient2;
		this.ingredient3 = card.ingredient3;
		this.ingredient4 = card.ingredient4;
		this.minLevel = 0;
		//cDesc = param1.desc;
		//cost = param1.cost;
		
		//damage = param1.damage;
		//moveDir = param1.moveDir;
		//attackString = param1.attackString;
		//defenseAmount = param1.defenseAmount;
		//regenerateAmount = param1.regenerateAmount;
		//healAmount = param1.healAmount;
		//magicId = param1.magicId;
		//color = param1.color;
		//ponAnimName = param1.ponAnimName;
		//magicAnimName = param1.magicAnimName;
		//animLength = param1.animLength;
		//animDelay = param1.animDelay;
		//magicAnimDepth = param1.magicAnimDepth;
		//sound = param1.sound;
		/* if (param1.hasOwnProperty("fixedLocation")) {
			fixedLocation = Std.string(param1.fixedLocation).split(",");
		} else {
			fixedLocation = [];
		} */
		//upgradeTo = param1.upgradeTo;
	/* 	upgradeDesc = param1.upgradeDesc;
		ingredient1 = param1.ingredient1;
		ingredient2 = param1.ingredient2;
		ingredient3 = param1.ingredient3;
		ingredient4 = param1.ingredient4;
		minLevel = param1.minLevel; */
	}

	public function setCardforUpgrade(upgradeScreen:BambaUpgradeSystem):Void {
		screen = upgradeScreen;
		mc.addEventListener(MouseEvent.CLICK, cardUpgradeClick);
		mc.buttonMode = true;
		mc.tabEnabled = false;
	}

	function addPopupEvents(param1:Dynamic):Void {
		screen = param1;
		mc.addEventListener(MouseEvent.ROLL_OVER, cardRolledOver);
		mc.addEventListener(MouseEvent.ROLL_OUT, cardRolledOut);
	}



	function cardUpgradeClick(param1:MouseEvent):Void {
		if (!game.msgShown) {
			screen.cardRollOver(id);
			screen.cardClicked(id);
		}
	}

	public function setCardDir(direction:Float):Void {
		mc.frontMC.shapeMC.scaleX = -direction;
	}

	function cardRolledOut(param1:MouseEvent):Void {
		screen.mc.removeChild(popupMC);
	}

	public function init(param1:Dynamic):Void {
		var _loc2_:Dynamic = null;
		game = param1;
		if (magicId != 0) {
			_loc2_ = game.gameData.getCatalogMagic(magicId);
			setMagicData(_loc2_);
		}
		if (animLength == 0) {
			animLength = game.gameData.defaultAnimLength;
		}
	}

	function setMagicData(param1:BambaMagic):Void {
		if (graphicsName == "") {
			graphicsName = param1.graphicsName;
		}
		if (attackString == "") {
			attackString = param1.attackString;
		}
		if (color == 0) {
			color = param1.color;
		}
		if (ponAnimName == "") {
			ponAnimName = param1.ponAnimName;
		}
		if (magicAnimName == "") {
			magicAnimName = param1.magicAnimName;
		}
		if (animLength == 0) {
			animLength = param1.animLength;
		}
		if (animDelay == 0) {
			animDelay = param1.animDelay;
		}
		if (magicAnimDepth == 0) {
			magicAnimDepth = param1.magicAnimDepth;
		}
		if (fixedLocation.length == 0) {
			fixedLocation = param1.fixedLocation;
		}
		if (sound == "") {
			sound = param1.sound;
		}
	}

	function cardRolledOver(param1:MouseEvent):Void {
		Heb.setText(popupMC.NAME, cName);
		Heb.setText(popupMC.DESC, cDesc);
		popupMC.x = Std.int(screen.mc.cardsMC.x) + Std.int(mc.x) + Std.int(mc.width);
		popupMC.y = Std.int(screen.mc.cardsMC.y) + Std.int(mc.y) + Std.int(mc.height) / 2;
		screen.mc.addChild(popupMC);
	}

	public function generateMC(direction:Float = 1):Void {
		if (mc == null) {
			mc = new CardBase();
			Heb.setText(mc.frontMC.nameDT, cName);
			mc.frontMC.damageDT.text = Std.string(damage);
			mc.frontMC.costDT.text = Std.string(cost);
			if (damage == 0 && healAmount > 0) {
				mc.frontMC.damageDT.text = "-" + healAmount;
			}
			var _textFormat = new TextFormat();
			var _colorTransform = new ColorTransform();
			var _colors:Array<Int> = game.gameData.dictionary.COLORS.split(",").map(color -> Std.parseInt(color));
			_textFormat.color = _colors[color - 1];
			_colorTransform.color = _colors[color - 1];
			mc.frontMC.nameDT.setTextFormat(_textFormat);
			mc.frontMC.damageDT.setTextFormat(_textFormat);
			mc.frontMC.costDT.setTextFormat(_textFormat);
			mc.frontMC.picMC.gotoAndStop(graphicsName);
			if (upgradeLevel == "") {
				mc.frontMC.upgradeMC.gotoAndStop(1);
			} else {
				mc.frontMC.upgradeMC.gotoAndStop(upgradeLevel);
			}
			for (i in 0...attackString.length) {
				if (attackString.charAt(i) == "1") {
					var _cubeString = "cube" + Std.string(i + 1);
					mc.frontMC.shapeMC.getChildByName(_cubeString).transform.colorTransform = _colorTransform;
				}
			}
			setCardDir(direction);
		}
		popupMC = new CardPopup();
	}
		

	function cardPickMC(param1:Int = 1):Void {
		var _loc2_:Dynamic = null;
		var _loc3_:TextFormat = null;
		var _loc4_:ColorTransform = null;
		var _loc5_:Dynamic = null;
		var _loc6_:Int = 0;
		var _loc7_:Dynamic = null;
		if (mc == null) {
			mc = new CardBase();
			Heb.setText(mc.frontMC.nameDT, cName);
			mc.frontMC.damageDT.text = Std.string(damage);
			mc.frontMC.costDT.text = Std.string(cost);
			if (damage == 0 && healAmount > 0) {
				mc.frontMC.damageDT.text = "-" + healAmount;
			}
			_loc3_ = new TextFormat();
			_loc4_ = new ColorTransform();
			_loc5_ = game.gameData.dictionary.COLORS.split(",");
			_loc3_.color = _loc5_[color - 1];
			_loc4_.color = _loc5_[color - 1];
			mc.frontMC.nameDT.setTextFormat(_loc3_);
			mc.frontMC.damageDT.setTextFormat(_loc3_);
			mc.frontMC.costDT.setTextFormat(_loc3_);
			mc.frontMC.picMC.gotoAndStop(graphicsName);
			if (upgradeLevel == "") {
				mc.frontMC.upgradeMC.gotoAndStop(1);
			} else {
				mc.frontMC.upgradeMC.gotoAndStop(upgradeLevel);
			}
			_loc6_ = 0;
			while (_loc6_ < attackString.length) {
				if (attackString.charAt(_loc6_) == "1") {
					_loc7_ = "cube" + Std.string(_loc6_ + 1);
					Reflect.getProperty(mc.frontMC.shapeMC, _loc7_).transform.colorTransform = _loc4_;
				}
				_loc6_++;
			}
			setCardDir(param1);
		}
		popupMC = new CardPopup();
	}

	function pickCard(param1:MouseEvent):Void {
		var _loc2_:Int = 0;
		var _loc3_:Int = 0;
		if (!game.msgShown) {
			if (picked == false) {
				if (disabled == false) {
					if (fight.cardPickedByPlayer[0] * fight.cardPickedByPlayer[1] * fight.cardPickedByPlayer[2] == 0) {
						game.sound.playEffect("BATTLE_CARD_PICK");
						picked = true;
						orgX = mc.x;
						orgY = mc.y;
						_loc2_ = 0;
						while (_loc2_ < 3) {
							if (fight.cardPickedByPlayer[_loc2_] == 0) {
								fight.MC.cardPickMC.cardsPickBoardMC.removeChild(mc);
								fight.MC.cardPickMC.cardsPickedMC.addChild(mc);
								mc.scaleX = 1;
								mc.scaleY = 1;
								mc.x = fight.cardPicksLocation[_loc2_][0];
								mc.y = fight.cardPicksLocation[_loc2_][1];
								fight.cardPickedByPlayer[_loc2_] = id;
								fight.costOfPickedCards = Std.int(fight.costOfPickedCards) + Std.int(cost) - Std.int(regenerateAmount);
								fight.disableExpensiveCards();
								break;
							}
							_loc2_++;
						}
					}
				}
			} else {
				game.sound.playEffect("BATTLE_CARD_PICK");
				picked = false;
				fight.MC.cardPickMC.cardsPickedMC.removeChild(mc);
				fight.MC.cardPickMC.cardsPickBoardMC.addChild(mc);
				mc.scaleX = 1;
				mc.scaleY = 1;
				mc.x = orgX;
				mc.y = orgY;
				_loc3_ = 0;
				while (_loc3_ < 3) {
					if (fight.cardPickedByPlayer[_loc3_] == id) {
						fight.cardPickedByPlayer[_loc3_] = 0;
						fight.costOfPickedCards = Std.int(fight.costOfPickedCards) - Std.int(cost) + Std.int(regenerateAmount);
						fight.disableExpensiveCards();
						break;
					}
					_loc3_++;
				}
			}
		}
	}

	function addClickEvent(param1:Dynamic):Void {
		mc.addEventListener(MouseEvent.CLICK, pickCard);
		mc.buttonMode = true;
		mc.tabEnabled = false;
		picked = false;
		fight = param1;
	}
}
