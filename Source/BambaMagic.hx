package;

import haxe.ds.Map;
import openfl.display.*;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;
import general.Heb;

typedef Magic = {
	id:Float,
	name:String,
	desc:String,
	graphicsname:String,
	order:Int, 
	firstcard:Int,
	cost:Int,
	minlevel:Int,
	color:Int,
	attackstring:String,
	ponanimname:String,
	magicanimname:String,
	animlength:Float,
	magicanimdepth:Float,
	sound:String,
	fixedlocation:String

}
class BambaMagic  {
	public var attackString:String;

	public var magicAnimDepth:Float;

	public var magicAnimName:String;

	public var mc:Dynamic;

	public var mName:String;

	public var id:Float;

	public var mDesc:String;

	public var sound:String;

	public var ponAnimName:String;

	public var graphicsName:String;

	public var magicBookScreen:Dynamic;

	public var fixedLocation:Array<Int>;

	public var isPicked:Bool;

	public var cost:Float;

	public var order:Float;

	public var minLevel:Float;

	public var animLength:Float;

	public var firstCard:Float;

	public var color:Int;

	public var animDelay:Float;

	public var disabled:Bool;

	public function new(magic:{sound:String, ponanimname:String, order:Int, name:String, minlevel:Int, magicanimname:String, magicanimdepth:Int, id:Int, graphicsname:String, fixedlocation:Array<Int>, firstcard:Int, desc:String, cost:Int, color:Int, attackstring:String, animlength:Float}) {
			this.id = magic.id;
			this.mName = magic.name;
			this.mDesc = magic.desc;
			this.graphicsName = magic.graphicsname;
			this.order = magic.order;
			this.firstCard = magic.firstcard;
			this.cost = magic.cost;
			this.minLevel = magic.minlevel;
			this.attackString = magic.attackstring.toString();
			this.color = magic.color;
			this.ponAnimName = magic.ponanimname;
			this.magicAnimName = magic.magicanimname;
			this.animLength = magic.animlength;
			this.animDelay = .0;
			this.magicAnimDepth = magic.magicanimdepth;
			this.sound = magic.sound;

		if (Reflect.hasField(magic, "fixedlocation")) {
			fixedLocation = magic.fixedlocation;
		} else {
			fixedLocation = [];
		}
		isPicked = false;
	}
	public function setGraphics():Void {
		var _loc1_:Bool = false;
		var _loc2_:Dynamic;
		var _loc3_:Int;
		if (minLevel <= magicBookScreen.game.gameData.playerData.level) {
			_loc1_ = false;
			_loc2_ = magicBookScreen.game.gameData.playerData.magic;
			_loc3_ = 0;
			while (_loc3_ < _loc2_.length) {
				if (id == _loc2_[_loc3_]) {
					_loc1_ = true;
					break;
				}
				_loc3_++;
			}
			if (_loc1_) {
				mc.gotoAndStop("own");
				disabled = true;
			} else if (isPicked) {
				mc.gotoAndStop("frame");
				disabled = false;
			} else {
				mc.gotoAndStop("reg");
				disabled = false;
				addClickEvent();
			}
		} else {
			mc.gotoAndStop("disable");
			disabled = true;
		}
	}

	function init(param1:Dynamic):Void {
		magicBookScreen = param1;
	}

	public function removeClickEvent():Void {
		if (mc.hasEventListener(MouseEvent.CLICK)) {
			mc.removeEventListener(MouseEvent.CLICK, magicClicked);
			mc.removeEventListener(MouseEvent.ROLL_OVER, mcRollOver);
			mc.removeEventListener(MouseEvent.ROLL_OUT, mcRollOut);
			mc.buttonMode = false;
		}
	}

	function mcRollOut(param1:MouseEvent):Void {
		if (!isPicked) {
			param1.currentTarget.gotoAndStop("reg");
		}
	}

	function mcRollOver(param1:MouseEvent):Void {
		if (!isPicked) {
			param1.currentTarget.gotoAndStop("rollover");
		}
	}

	function magicClicked(param1:MouseEvent):Void {
		if (!magicBookScreen.game.msgShown) {
			magicBookScreen.magicClicked(id);
		}
	}

	function generateMC():Void {
		var _loc1_:BambaCard;
		var _loc2_:ColorTransform;
		var _loc3_:Dynamic;
		var _loc4_:Int;
		var _loc5_:String;
		if (mc == null) {
			mc = BambaAssets.magicBase();
			Heb.setText(mc.textMC.nameDT, mName);
			Heb.setText(mc.textMC.descDT, mDesc);
			mc.textMC.priceDT.text = cost;
			mc.textMC.minLevelDT.text = minLevel;
			_loc1_ = magicBookScreen.game.gameData.getCatalogCard(firstCard);
			mc.textMC.magicDT.text = _loc1_.cost;
			mc.textMC.damageDT.text = _loc1_.damage;
			if (graphicsName != "") {
				mc.picMC.gotoAndStop(graphicsName);
			} else {
				mc.picMC.gotoAndStop(1);
			}
			_loc2_ = new ColorTransform();
			_loc3_ = magicBookScreen.game.gameData.dictionary.COLORS.split(",");
			_loc2_.color = _loc3_[color - 1];
			_loc4_ = 0;
			while (_loc4_ < _loc1_.attackString.length) {
				if (_loc1_.attackString.charAt(_loc4_) == "1") {
					_loc5_ = "cube" + Std.string(_loc4_ + 1);
					var shapeMc:MovieClip = Reflect.getProperty(mc, _loc5_);
					shapeMc.transform.colorTransform = _loc2_;
				}
				_loc4_++;
			}
		}
	}

	function addClickEvent():Void {
		if (disabled == false) {
			mc.addEventListener(MouseEvent.CLICK, magicClicked);
			mc.addEventListener(MouseEvent.ROLL_OVER, mcRollOver);
			mc.addEventListener(MouseEvent.ROLL_OUT, mcRollOut);
			mc.buttonMode = true;
			mc.tabEnabled = false;
			mc.mouseChildren = false;
		}
	}
}
