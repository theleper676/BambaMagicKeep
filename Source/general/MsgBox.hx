package general;

import general_assets.WaitBox;
import general_assets.WinBox;
import general_assets.LevelBox;
import general_assets.QuestBox;
import general_assets.PrizeIcon;
import general_assets.YesNoBox;
import openfl.display.*;
import openfl.events.MouseEvent;

class MsgBox extends DisplayObject  {
	static var yesNoBoxLink:Null<Dynamic>;

	static var msgBoxCloseFunction:Null<Dynamic>;

	static var waitBoxCloseFunction:Null<Dynamic>;

	static var needToShowLevelBox:Bool;

	static var yesNoConfirmFunction:Dynamic;

	static var yesNoCancelFunction:Null<Dynamic>;

	static var game:BambaMain;

	static var waitBoxLink:Null<Dynamic>;

	static var msgBoxMCLink:Null<Dynamic>;

	public static var version:Float = 1;

	static var bambaAssets: Dynamic;

	public function new() {
		super();
		needToShowLevelBox = false;
	}

	public static function showYesNoBox(yesNoBoxText:String, _yesNoConfirmFunction:Dynamic, _yesNoCancelFunction:Dynamic = null, yesNoBoxText:String = null):Void {
		var _yesNoBox = new YesNoBox();
		yesNoBoxLink = _yesNoBox;
		yesNoConfirmFunction = _yesNoConfirmFunction;
		yesNoCancelFunction = _yesNoCancelFunction;
		game.addChild(_yesNoBox);
		game.msgShown = true;
		game.centerScreen(_yesNoBox);
		ButtonUpdater.setButton(_yesNoBox.confirmButton, yesNoConfirm);
		ButtonUpdater.setButton(_yesNoBox.cancelButton, yesNoCancel);
		Heb.setText(_yesNoBox.dt, yesNoBoxText);
		if (yesNoBoxText != null) {
			var _prizeIcon = new PrizeIcon();
			_yesNoBox.addChild(_prizeIcon);
			_prizeIcon.iconMC.gotoAndStop(1);
			_prizeIcon.DT.text = yesNoBoxText;
			_prizeIcon.x = 115;
			_prizeIcon.y = 95;
			_prizeIcon.scaleX = 1.5;
			_prizeIcon.scaleY = 1.5;
		}
	}

	public static function showLevelBox():Void {
		needToShowLevelBox = false;
		var _levelBox = new LevelBox();
		msgBoxMCLink = _levelBox;
		game.addChild(_levelBox);
		game.msgShown = true;
		game.centerScreen(_levelBox);
		ButtonUpdater.setButton(_levelBox.exitButton, closeMsgBox);
		Heb.setText(_levelBox.headDT, game.gameData.dictionary.LEVEL_UP_MSG_HEAD);
		Heb.setText(_levelBox.dt, game.gameData.dictionary.LEVEL_UP_MSG);
		_levelBox.levelDT.text = Std.string(game.gameData.playerData.level);
		Heb.setText(_levelBox.LIFE, game.gameData.dictionary.LIFE);
		Heb.setText(_levelBox.MAGIC, game.gameData.dictionary.MAGIC);
		Heb.setText(_levelBox.REGENERATION, game.gameData.dictionary.REGENERATION);
		var _playerLevelIdMinusOne = game.gameData.playerData.level - 1;
		var _playerLevelId = game.gameData.playerData.level;
		var _maxLifeDelta = game.gameData.getCatalogPlayerLevel(_playerLevelIdMinusOne).maxLife - game.gameData.getCatalogPlayerLevel(_playerLevelIdMinusOne).maxLife;
		var _maxMagicDelta = game.gameData.getCatalogPlayerLevel(_playerLevelId).maxMagic - game.gameData.getCatalogPlayerLevel(_playerLevelIdMinusOne).maxMagic;
		var _regenerationDTDelta = game.gameData.getCatalogPlayerLevel(_playerLevelId).roundRegeneration - game.gameData.getCatalogPlayerLevel(_playerLevelIdMinusOne).roundRegeneration;
		_levelBox.lifeDT.text = "+" + _maxLifeDelta;
		_levelBox.magicDT.text = "+" + _maxMagicDelta;
		_levelBox.regenerationDT.text = "+" + _regenerationDTDelta;
		game.sound.playEffect("GENERAL_LEVEL_UP");
	}

	public static function updateWaitBox(param1:Float):Void {
		waitBoxLink.prcMC.dt.text = param1 + "%";
		waitBoxLink.flareMC.x = 46 + 505 - 505 * param1 / 100;
		waitBoxLink.maskMC.width = 505 * param1 / 100;
		waitBoxLink.maskMC.x = 46 + 505 - 505 * param1 / 100;
	}

	public static function init(param1:Dynamic):Void {
		game = param1;
	}

	public static function showWaitBox(param1:String, waitBoxFunction:Dynamic = null):Void {
		//var _loc3_:Dynamic = null;
		var _waitBox = new WaitBox();
		waitBoxLink = _waitBox;
		waitBoxCloseFunction = waitBoxFunction;
		updateWaitBox(0);
		game.addChild(_waitBox);
		game.msgShown = true;
		Heb.setText(_waitBox.dt, param1);
		game.centerScreen(_waitBox);
	}

	static function yesNoConfirm(param1:MouseEvent):Void {
		game.sound.playEffect("GENERAL_MENU_CLICK");
		game.removeChild(yesNoBoxLink);
		game.msgShown = false;
		if (yesNoConfirmFunction != null) {
			yesNoConfirmFunction.call();
		}
	}

	public static function updateWaitBoxTxt(param1:String):Void {
		Heb.setText(waitBoxLink.dt, param1);
	}

	public static function showWin(winBoxText:String, param2:Array<Dynamic>, _msgBoxCloseFunction:Dynamic = null, iconMCMarker:Float = 1):Void {
		var _winBox = new WinBox();
		var _winMsg:String = "";
		var _expPointMsg: String = "";
		msgBoxMCLink = _winBox;
		msgBoxCloseFunction = _msgBoxCloseFunction;
		game.addChild(_winBox);
		game.msgShown = true;
		game.centerScreen(_winBox);
		ButtonUpdater.setButton(_winBox.exitButton, closeMsgBox);
		if (param2[0] != 0) {
			_winMsg = game.gameData.dictionary.MSG_WIN1;
			_expPointMsg = param2[0] + " " + game.gameData.dictionary.EXPOINTS;
			if (param2[1] > 0) {
				needToShowLevelBox = true;
			}
		}
		Heb.setText(_winBox.headDT, winBoxText);
		Heb.setText(_winBox.dt1, _winMsg);
		Heb.setText(_winBox.dt2, _expPointMsg);
		_winBox.iconMC.gotoAndStop(iconMCMarker);
		if (param2[2] != null) {
			var _loc6_ = 0;
			while (_loc6_ < param2[2].length) {
				var _bambaItem = new BambaItem(game.gameData.getCatalogItem(param2[2][_loc6_]).data);
				_bambaItem.init(game);
				_bambaItem.generateMC();
				_bambaItem.addPopupInMsg(msgBoxMCLink);
				_winBox.prizesMC.addChild(_bambaItem.mc);
				_loc6_++;
			}
		}
		if (param2[3] != null) {
			if (param2[3] > 0) {
				var _prizeIcon = new PrizeIcon();
				_winBox.prizesMC.addChild(_prizeIcon);
				_prizeIcon.iconMC.gotoAndStop(1);
				_prizeIcon.DT.text = param2[3];
			}
		}
		switch (_winBox.prizesMC.numChildren) {
			case 1:
				_winBox.prizesMC.getChildAt(0).x = 60;
				_winBox.prizesMC.getChildAt(0).y = 0;
				_winBox.prizesMC.getChildAt(0).scaleX = 1.5;
				_winBox.prizesMC.getChildAt(0).scaleY = 1.5;
			case 2:
				_winBox.prizesMC.getChildAt(1).x = 0;
				_winBox.prizesMC.getChildAt(1).y = 0;
				_winBox.prizesMC.getChildAt(1).scaleX = 1.5;
				_winBox.prizesMC.getChildAt(1).scaleY = 1.5;
				_winBox.prizesMC.getChildAt(0).x = 120;
				_winBox.prizesMC.getChildAt(0).y = 0;
				_winBox.prizesMC.getChildAt(0).scaleX = 1.5;
				_winBox.prizesMC.getChildAt(0).scaleY = 1.5;
		}
		var _loc6_ = 0;
		while (_loc6_ < param2.length - 4) {
			if (param2[_loc6_ + 4] > 0) {
				var _prizeIcon = new PrizeIcon();
				_winBox.ingredientsMC.addChild(_prizeIcon);
				_prizeIcon.iconMC.gotoAndStop(_loc6_ + 2);
				_prizeIcon.DT.text = param2[_loc6_ + 4];
			}
			_loc6_++;
		}
		switch (_winBox.ingredientsMC.numChildren) {
			case 1:
				_winBox.ingredientsMC.getChildAt(0).x = 80;
				_winBox.ingredientsMC.getChildAt(0).y = 20;
			case 2:
				_winBox.ingredientsMC.getChildAt(1).x = 40;
				_winBox.ingredientsMC.getChildAt(1).y = 20;
				_winBox.ingredientsMC.getChildAt(0).x = 120;
				_winBox.ingredientsMC.getChildAt(0).y = 20;
			case 3:
				_winBox.ingredientsMC.getChildAt(2).x = 80;
				_winBox.ingredientsMC.getChildAt(2).y = 45;
				_winBox.ingredientsMC.getChildAt(1).x = 40;
				_winBox.ingredientsMC.getChildAt(1).y = 0;
				_winBox.ingredientsMC.getChildAt(0).x = 120;
				_winBox.ingredientsMC.getChildAt(0).y = 0;
			case 4:
				_winBox.ingredientsMC.getChildAt(3).x = 40;
				_winBox.ingredientsMC.getChildAt(3).y = 45;
				_winBox.ingredientsMC.getChildAt(2).x = 120;
				_winBox.ingredientsMC.getChildAt(2).y = 45;
				_winBox.ingredientsMC.getChildAt(1).x = 40;
				_winBox.ingredientsMC.getChildAt(1).y = 0;
				_winBox.ingredientsMC.getChildAt(0).x = 120;
				_winBox.ingredientsMC.getChildAt(0).y = 0;
		}
	}

	static function closeMsgBox(param1:MouseEvent):Void {
		game.sound.playEffect("GENERAL_MENU_CLICK");
		game.removeChild(msgBoxMCLink);
		if (needToShowLevelBox) {
			showLevelBox();
		} else {
			game.msgShown = false;
			if (msgBoxCloseFunction != null) {
				msgBoxCloseFunction.call();
			}
		}
	}

	public static function showQuestBox(questBoxText:String, questIconMCMarker:Float, param3:Array<Dynamic>, _msgBoxCloseFunction:Dynamic = null):Void {
		var _questBox = new QuestBox();
		msgBoxMCLink = _questBox;
		msgBoxCloseFunction = _msgBoxCloseFunction;
		game.addChild(_questBox);
		game.msgShown = true;
		game.centerScreen(_questBox);
		ButtonUpdater.setButton(_questBox.exitButton, closeMsgBox);
		if (param3[1] > 0) {
			needToShowLevelBox = true;
		}
		Heb.setText(_questBox.headDT, game.gameData.dictionary.QUEST_MSG_HEAD);
		Heb.setText(_questBox.dt, questBoxText);
		Heb.setText(_questBox.EXPOINTS, game.gameData.dictionary.EXPOINTS);
		_questBox.exPointsDT.text = param3[0];
		_questBox.prizeMC.DT.text = param3[3];
		_questBox.questIconMC.gotoAndStop(questIconMCMarker);
		_questBox.prizeMC.prizeIconMC.gotoAndStop(1);
		game.sound.playEffect("MAZE_QUEST_WIN");
	}

	static function yesNoCancel(param1:MouseEvent):Void {
		game.sound.playEffect("GENERAL_MENU_CLICK");
		game.removeChild(yesNoBoxLink);
		game.msgShown = false;
		if (yesNoCancelFunction != null) {
			yesNoCancelFunction.call();
		}
	}

	public static function show(text:String, closeFunction:Dynamic = null, iconId:Float = 4):Void {
		var _msgBox = new general_assets.MsgBox();
		msgBoxMCLink = _msgBox;
		msgBoxCloseFunction = closeFunction;
		game.addChild(_msgBox);
		game.msgShown = true;
		game.centerScreen(_msgBox);
		ButtonUpdater.setButton(_msgBox.exitButton, closeMsgBox);
		Heb.setText(_msgBox.dt, text);
		_msgBox.iconMC.gotoAndStop(iconId);
	}

	public static function closeWaitBox():Void {
		game.msgShown = false;
		game.removeChild(waitBoxLink);
		if (waitBoxCloseFunction != null) {
			waitBoxCloseFunction.call();
		}
	}
}
