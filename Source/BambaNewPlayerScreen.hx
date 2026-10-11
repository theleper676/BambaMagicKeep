package;

import new_player.NewPlayerScreen;
import haxe.ui.components.DropDown;
import haxe.ui.data.ArrayDataSource;
import haxe.Timer;
import openfl.display.*;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.ui.Keyboard;
import openfl.utils.*;
import general.ButtonUpdater;
import general.MsgBox;

typedef Mc = {
	screenMC: Dynamic
} 

class BambaNewPlayerScreen extends Sprite {
	var isIn:Bool;

	var game:BambaMain;

	public var mc:NewPlayerScreen;

	var clickCountIntervalTimer: Timer = null;
	var clickContInterval:Float;

	public function new(mainGame:BambaMain) {
		super();
		game = mainGame;
		mc = new NewPlayerScreen();
		ButtonUpdater.setButton(mc.screenMC.enterMC, enterClicked);
		ButtonUpdater.setButton(mc.screenMC.backMC, backClicked);
		mc.screenMC.passIT.displayAsPassword = true;
		mc.screenMC.confirmPassIT.displayAsPassword = true;
		game.stage.addEventListener(MouseEvent.CLICK, setFocusOnUser);
		mc.screenMC.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
		mc.screenMC.userIT.tabIndex = 1;
		mc.screenMC.passIT.tabIndex = 2;
		mc.screenMC.confirmPassIT.tabIndex = 3;
		mc.screenMC.mailIT.tabIndex = 4;
		buildDateDropDowns();
		isIn = false;
	}

	/**
		The birthdate pickers were Flash `fl.controls.ComboBox` components. OpenFL has no
		equivalent, so the port retyped the generated fields as HaxeUI DropDowns - but nothing
		ever created them, leaving yearCB/monthCB/dayCB null and crashing the constructor.

		The SWF still carries a placeholder clip for each one (the symbol class does not resolve,
		so it comes through as a plain MovieClip named yearCB/monthCB/dayCB). Each placeholder is
		measured, removed, and replaced by a real DropDown in the same spot.
	**/
	function buildDateDropDowns():Void {
		var now = Date.now().getFullYear();
		var years = [for (i in 0...101) Std.string(now - i)];
		var months = [for (m in 1...13) StringTools.lpad(Std.string(m), "0", 2)];
		var days = [for (d in 1...32) StringTools.lpad(Std.string(d), "0", 2)];

		mc.screenMC.yearCB = buildDateDropDown("yearCB", years, 5);
		mc.screenMC.monthCB = buildDateDropDown("monthCB", months, 6);
		mc.screenMC.dayCB = buildDateDropDown("dayCB", days, 7);
	}

	function buildDateDropDown(name:String, values:Array<String>, tabIndex:Int):DropDown {
		var dropDown = new DropDown();

		var placeholder = mc.screenMC.getChildByName(name);
		if (placeholder != null) {
			dropDown.left = placeholder.x;
			dropDown.top = placeholder.y;
			dropDown.width = placeholder.width;
			dropDown.height = placeholder.height;
			mc.screenMC.removeChild(placeholder);
		} else {
			trace("BambaNewPlayerScreen: no placeholder clip named '" + name + "' in the SWF");
		}

		var data = new ArrayDataSource<Dynamic>();
		for (value in values) {
			data.add({text: value});
		}
		dropDown.dataSource = data;
		dropDown.tabIndex = tabIndex;

		mc.screenMC.addChild(dropDown);
		// After addChild: HaxeUI does not apply a selection to a component that is not yet live.
		dropDown.selectedIndex = 0;
		return dropDown;
	}

	/**
		The value a picker is showing. `selectedItem` can still be null even after selectedIndex
		is set, because HaxeUI applies selection lazily, so fall back to reading the data source
		directly at the selected index.
	**/
	function pickerValue(dropDown:DropDown):String {
		if (dropDown == null) {
			return null;
		}
		var item:Dynamic = dropDown.selectedItem;
		if (item != null && item.text != null) {
			return Std.string(item.text);
		}
		var index = dropDown.selectedIndex < 0 ? 0 : dropDown.selectedIndex;
		var data = dropDown.dataSource;
		if (data != null && index < data.size) {
			var fallback:Dynamic = data.get(index);
			if (fallback != null && fallback.text != null) {
				return Std.string(fallback.text);
			}
		}
		return null;
	}

	// Birthdate as YYYYMMDD; null if any picker has no value.
	function birthDateString():String {
		var year = pickerValue(mc.screenMC.yearCB);
		var month = pickerValue(mc.screenMC.monthCB);
		var day = pickerValue(mc.screenMC.dayCB);
		if (year == null || month == null || day == null) {
			return null;
		}
		return year + month + day;
	}

	/**
		Puts the caret in the user name field on the first click, unless that click already
		landed on a text field - then it is the player picking a field and redirecting would
		take it straight back off them.
	**/
	function setFocusOnUser(param1:MouseEvent):Void {
		game.stage.removeEventListener(MouseEvent.CLICK, setFocusOnUser);
		if (Std.isOfType(param1.target, TextField)) return;
		game.stage.focus = mc.screenMC.userIT;
	}

	function validateMailAddressChars(param1:String):Bool {
		var _loc2_:Bool = false;
		_loc2_ = true;
		if (param1.length <= 0) {
			_loc2_ = false;
		}
		if (param1.indexOf("<") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf(">") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf("\\") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf(";") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf(":") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf("]") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf("(") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf(")") != -1) {
			_loc2_ = false;
		}
		if (param1.indexOf("[") != -1) {
			_loc2_ = false;
		}
		trace("Checked email address and it is:" + Std.string(_loc2_));
		return _loc2_;
	}

	function checkEnter():Void {
		var _loc1_:Null<Dynamic> = null;
		if (!game.msgShown) {
			if (mc.screenMC.userIT.text.length < 3) {
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_MIN_NAME);
				return;
			}
			if (mc.screenMC.passIT.text.length < 3) {
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_MIN_PASS);
				return;
			}
			if (mc.screenMC.passIT.text != mc.screenMC.confirmPassIT.text) {
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_NO_IDENTIC_PASS);
				return;
			}
			if (!validateMailAddressChars(mc.screenMC.mailIT.text)) {
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_ILLEGAL_MAIL);
				return;
			}
			game.opening.saveUserPass(mc.screenMC.userIT.text, mc.screenMC.passIT.text);
			_loc1_ = "";
			_loc1_ = birthDateString();
			if (_loc1_ == null) {
				MsgBox.show(game.gameData.dictionary.NEW_PLAYER_ILLEGAL_MAIL);
				return;
			}
			game.gameLoader.sendNewPlayerData(mc.screenMC.userIT.text, mc.screenMC.passIT.text, mc.screenMC.mailIT.text, _loc1_);
		}
	}

	function keyPressedDown(param1:KeyboardEvent):Void {
		var _loc2_:Int = 0;
		if (!game.msgShown) {
			_loc2_ = param1.keyCode;
			switch (_loc2_) {
				case Keyboard.ENTER:
					checkEnter();
			}
		}
	}

	public function slideOut():Void {
		game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
		utils.Timeline.playSegment(mc, "slideOut");
	}

	function backClicked(param1:MouseEvent):Void {
		slideOut();
		clickCountIntervalTimer = new Timer(500);
		clickCountIntervalTimer.run = backClickedCont;
		//clickContInterval = setInterval(backClickedCont, 500);
	}

	function backClickedCont():Void {
		if (clickCountIntervalTimer != null) clickCountIntervalTimer.stop();
		// clearInterval(clickContInterval);
		game.exitToOpeningScreen();
	}

	function enterClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			checkEnter();
		}
	}

	public function slideIn():Void {
		if (!isIn) {
			game.sound.playEffect("GENERAL_MENU_SLIDE_IN");
			utils.Timeline.playSegment(mc, "slideIn");
			isIn = true;
		}
	}
}
