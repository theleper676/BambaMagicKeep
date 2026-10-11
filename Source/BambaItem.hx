package;

import items.*;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import items.StickMC;
import openfl.events.MouseEvent;
import openfl.text.TextFormat;
import general.Heb;

class BambaItem {
	public var addMagic:Float;

	public var iName:String;

	public var mc:MovieClip;

	public var sellPrice:Float;

	public var iDesc:String;

	public var id:Float;

	public var addRoundRegeneration:Float;

	public var graphicsName:String;

	public var iType:Int;

	public var addLife:Float;

	public var popupMC:ItemPopup;

	public var frameMC:ItemFrame;

	public var screenType:Float;

	public var base:Float;

	public var minLevel:Float;

	public var data:{id:Int, graphicsname:String, base:Int};

	public var buyPrice:Float;

	public var indexInScreen:Dynamic;

	public var game:BambaMain;

	public var line:Dynamic;

	public var screen:Dynamic;

	public function new(item:{id:Int, graphicsname:String, base:Int}) {
		data = item;
		this.id = item.id;
		this.base = item.base;
		this.iName = "";
		this.iDesc = "";
		this.iType = 0;
		this.buyPrice = 0;
		this.sellPrice = 0;
		this.minLevel = 0;
		this.addLife = 0;
		this.addMagic = 0;
		this.addRoundRegeneration = 0;
		this.graphicsName = item.graphicsname;
	}

	function itemClickedOnBaby(param1:MouseEvent):Void {
		if (!game.msgShown) {
			screen.itemClickedOnBaby(id);
		}
	}

	public function init(game:BambaMain):Void {
		this.game = game;
		if (base != 0) {
			var _itemBase = game.gameData.getCatalogItemBase(base);
			setItemBaseData(_itemBase);
		}
	}

	function itemRolledOverInMsg(param1:MouseEvent):Void {
		setBasicPopupText();
		popupMC.PRICE.text = "";
		popupMC.priceDT.text = "";
		// Here `screen` is the win box itself; placed from the item's real position, since
		// `screen.prizesMC.x` through Dynamic throws "Invalid field" on hxcpp.
		var box:DisplayObjectContainer = cast screen;
		var at = box.globalToLocal(mc.localToGlobal(new openfl.geom.Point(mc.width, mc.height / 2)));
		popupMC.x = at.x;
		popupMC.y = at.y;
		box.addChild(popupMC);
	}

	function itemClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			screen.itemClicked(id, indexInScreen);
		}
	}

	function charecterBuildClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			screen.itemClicked(id, line, indexInScreen);
		}
	}

	public function addClickEventOnBaby(param1:Dynamic):Void {
		screen = param1;
		frameMC.gotoAndStop("onBaby");
		mc.addEventListener(MouseEvent.CLICK, itemClickedOnBaby);
		mc.buttonMode = true;
		mc.tabEnabled = false;
		mc.addEventListener(MouseEvent.ROLL_OVER, itemRolledOverOnBaby);
		mc.addEventListener(MouseEvent.ROLL_OUT, itemRolledOut);
	}

	function itemStoreClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			screen.itemStoreClicked(id, indexInScreen);
		}
	}

	public function generateMC():Void {
		if (mc == null) {
			switch (iType) {
				case 1:
					mc = new HatMC();
				case 2:
					mc = new CapeMC();
				case 3:
					mc = new BeltMC();
				case 4:
					mc = new ShoesMC();
				case 5:
					mc = new StickMC();
				case 6:
					mc = new HairMC();
				case 7:
					mc = new EyesMC();
				case 8:
					mc = new DaiperMC();
			}
			mc.gotoAndStop(graphicsName);
			frameMC = new ItemFrame();
			mc.name = Std.string(id);
			mc.addChild(frameMC);
			mc.setChildIndex(frameMC, 0);
			popupMC = new ItemPopup();
		}
	}

	function setItemBaseData(itemBase:BambaItemBase):Void {
		if (iName == "") {
			iName = itemBase.iName;
		}
		if (iDesc == "") {
			iDesc = itemBase.iDesc;
		}
		if (iType == 0) {
			iType = itemBase.iType;
		}
		if (buyPrice == 0) {
			buyPrice = itemBase.buyPrice;
		}
		if (sellPrice == 0) {
			sellPrice = itemBase.sellPrice;
		}
		if (minLevel == 0) {
			minLevel = itemBase.minLevel;
		}
		if (addLife == 0) {
			addLife = itemBase.addLife;
		}
		if (addMagic == 0) {
			addMagic = itemBase.addMagic;
		}
		if (addRoundRegeneration == 0) {
			addRoundRegeneration = itemBase.addRoundRegeneration;
		}
	}

	public function addCharecterBuildClickEvent(screen:Dynamic, line:Int, tabIndex:Int):Void {
		mc.addEventListener(MouseEvent.CLICK, charecterBuildClicked);
		mc.buttonMode = true;
		mc.tabEnabled = false;
		this.screen = screen;
		indexInScreen = tabIndex;
		this.line = line;
		frameMC.gotoAndStop("reg");
	}

	public function addStoreClickEvent(param1:Dynamic, param2:Dynamic):Void {
		mc.addEventListener(MouseEvent.CLICK, itemStoreClicked);
		mc.buttonMode = true;
		mc.tabEnabled = false;
		screen = param1;
		indexInScreen = param2;
		if (minLevel <= screen.game.gameData.playerData.level) {
			frameMC.gotoAndStop("reg");
			frameMC.backMC.gotoAndStop(2);
			mc.mouseEnabled = false;
		} else {
			frameMC.gotoAndStop("disable");
			frameMC.backMC.gotoAndStop(2);
			mc.mouseEnabled = true;
		}
		mc.addEventListener(MouseEvent.ROLL_OVER, itemStoreRolledOver);
		mc.addEventListener(MouseEvent.ROLL_OUT, itemRolledOut);
	}

	function itemRolledOver(param1:MouseEvent):Void {
		if (!game.msgShown) {
			setBasicPopupText();
			if (screenType == 1) {
				popupMC.PRICE.text = "";
				popupMC.priceDT.text = "";
			} else {
				Heb.setText(popupMC.PRICE, game.gameData.dictionary.PRICE_SELL + ":");
				popupMC.priceDT.text = Std.string(sellPrice);
			}
			showPopupBesideItem();
		}
	}

	function itemRolledOutInMsg(param1:MouseEvent):Void {
		var box:DisplayObjectContainer = cast screen;
		if (box.contains(popupMC)) {
			box.removeChild(popupMC);
		}
	}

	public function addPopupInMsg(param1:Dynamic):Void {
		screen = param1;
		frameMC.gotoAndStop("noBack");
		mc.addEventListener(MouseEvent.ROLL_OVER, itemRolledOverInMsg);
		mc.addEventListener(MouseEvent.ROLL_OUT, itemRolledOutInMsg);
	}

	/** One of the three stats an item adds, by the name setBasicPopupText passes. **/
	static function statOf(item:BambaItem, stat:String):Float {
		return switch (stat) {
			case "addLife": item.addLife;
			case "addMagic": item.addMagic;
			case "addRoundRegeneration": item.addRoundRegeneration;
			default: 0;
		}
	}

	/**
		Writes a stat into the popup, green if it beats the item worn in the same slot, red if
		it is worse. Typed: the field was Dynamic, and setting `.text` through it threw
		"Invalid field:text" on hxcpp as soon as an item was hovered. The comparison with the
		worn item was left as a TODO in the port and is restored here.
	**/
	function setColorAndText(field:openfl.text.TextField, stat:String):Void {
		if (field == null) return;
		var value = statOf(this, stat);
		var wornId:Dynamic = game.gameData.playerData.itemsInUse[iType - 1];
		var worn = wornId != null && wornId > 0 ? game.gameData.getCatalogItem(wornId) : null;
		var wornValue = worn != null ? statOf(worn, stat) : 0;
		field.text = "+" + value;
		var format = new TextFormat();
		if (wornValue < value) {
			format.color = 0x2ED51C;
			format.bold = true;
		} else if (wornValue > value) {
			format.color = 0xFF6372;
			format.bold = true;
		} else {
			format.color = 0xFFE696;
			format.bold = false;
		}
		field.setTextFormat(format);
	}

	function setBasicPopupText():Void {
		var _loc1_:TextFormat = null;
		Heb.setText(popupMC.NAME, iName);
		Heb.setText(popupMC.DESC, iDesc);
		Heb.setText(popupMC.LIFE, game.gameData.dictionary.LIFE + ":");
		Heb.setText(popupMC.MAGIC, game.gameData.dictionary.MAGIC + ":");
		Heb.setText(popupMC.REGENERATION, game.gameData.dictionary.REGENERATION + ":");
		Heb.setText(popupMC.MIN_LEVEL, game.gameData.dictionary.MIN_LEVEL + ":");
		setColorAndText(popupMC.lifeDT, "addLife");
		setColorAndText(popupMC.magicDT, "addMagic");
		setColorAndText(popupMC.regenerationDT, "addRoundRegeneration");
		popupMC.minLevelDT.text = Std.string(minLevel);
		if (minLevel > game.gameData.playerData.level) {
			_loc1_ = new TextFormat();
			_loc1_.color = 0xF35454;
			_loc1_.bold = true;
			popupMC.minLevelDT.setTextFormat(_loc1_);
			popupMC.MIN_LEVEL.setTextFormat(_loc1_);
		}
	}

	public function addClickEvent(param1:Dynamic, param2:Dynamic, param3:Dynamic):Void {
		mc.addEventListener(MouseEvent.CLICK, itemClicked);
		mc.buttonMode = true;
		mc.tabEnabled = false;
		screen = param1;
		screenType = param3;
		indexInScreen = param2;
		if (minLevel <= screen.game.gameData.playerData.level) {
			frameMC.gotoAndStop("reg");
			mc.mouseEnabled = false;
		} else {
			frameMC.gotoAndStop("disable");
			mc.mouseEnabled = true;
		}
		mc.addEventListener(MouseEvent.ROLL_OVER, itemRolledOver);
		mc.addEventListener(MouseEvent.ROLL_OUT, itemRolledOut);
	}

	function itemRolledOverOnBaby(param1:MouseEvent):Void {
		if (!game.msgShown) {
			setBasicPopupText();
			popupMC.PRICE.text = "";
			popupMC.priceDT.text = "";
			var slotNames = ["hatMC", "capeMC", "beltMC", "shoesMC", "stickMC"];
			popupMC.backMC.gotoAndStop(2);
			// Typed lookups: `babyMC[name]` on a Dynamic is AS3 syntax that hxcpp can't resolve,
			// and a Dynamic `.x` throws "Invalid field:x".
			var babyMC:DisplayObjectContainer = cast screen.mc.babyMC;
			var slot = babyMC.getChildByName(slotNames[iType - 1]);
			if (slot != null) {
				popupMC.x = slot.x + babyMC.x - popupMC.backMC.width;
				popupMC.y = slot.y + babyMC.y + frameMC.height / 2;
			}
			(cast screen.mc : DisplayObjectContainer).addChild(popupMC);
		}
	}

	function itemStoreRolledOver(param1:MouseEvent):Void {
		if (!game.msgShown) {
			setBasicPopupText();
			Heb.setText(popupMC.PRICE, game.gameData.dictionary.PRICE + ":");
			popupMC.priceDT.text = Std.string(buyPrice);
			showPopupBesideItem();
		}
	}

	function itemRolledOut(param1:MouseEvent):Void {
		var screenMC:DisplayObjectContainer = cast screen.mc;
		if (screenMC.contains(popupMC)) {
			screenMC.removeChild(popupMC);
		}
	}

	/**
		Puts the popup to the right of this item, mid-height, on the item's screen. Worked out
		from where the item really is (localToGlobal), which already includes the list's
		scroll - the AS3 added the ScrollPane's position and verticalScrollPosition, which the
		port reached through Dynamic ("Invalid field" on hxcpp) and which utils.ClipScroller
		replaced anyway.
	**/
	function showPopupBesideItem():Void {
		var screenMC:DisplayObjectContainer = cast screen.mc;
		var at = screenMC.globalToLocal(mc.localToGlobal(new openfl.geom.Point(frameMC.width, frameMC.height / 2)));
		popupMC.x = at.x;
		popupMC.y = at.y;
		screenMC.addChild(popupMC);
	}
}
