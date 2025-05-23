package;

import tower_screens.MagicBookScreen;
import openfl.display.DisplayObject;
import opefl.display.*;
import openfl.events.MouseEvent;
import general.ButtonUpdater;
import general.MsgBox;
import general.PlayerDataUpdater;

class BambaMagicBook extends DisplayObject {
	var magicBookArray:Array<BambaMagic>;

	public var game:BambaMain;

	var currMagicId:Float;

	public var mc:MagicBookScreen;

	public function new(mainGame:BambaMain) {
		super();
		game = mainGame;
		magicBookArray = [];
		mc = new MagicBookScreen();
		ButtonUpdater.setButton(mc.buyMC, buyClicked);
		ButtonUpdater.setButton(mc.exitMC, exitClicked);
		currMagicId = 0;
		update();
	}

	function buyClicked(param1:MouseEvent):Void {
		var _loc2_:BambaMagic = null;
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currMagicId != 0) {
				_loc2_ = game.gameData.getCatalogMagic(currMagicId);
				if (_loc2_.cost > game.gameData.playerData.money) {
					MsgBox.show(game.gameData.dictionary.MAGIC_NOT_ENOUGH_MONEY);
				} else {
					game.help.showTutorial(21);
					game.sound.playEffect("TOWER_MAGIC_BUY");
					game.gameData.playerData.addMagic(currMagicId);
					game.gameData.playerData.addCard(_loc2_.firstCard);
					game.gameData.playerData.money -= _loc2_.cost;
					_loc2_.setGraphics();
					_loc2_.removeClickEvent();
					_loc2_ = null;
					currMagicId = 0;
					PlayerDataUpdater.updateMoneyData(mc.moneyMC);
					update();
					game.gameLoader.savePlayerData();
				}
			} else {
				game.sound.playEffect("GENERAL_UNAVIALABLE");
				MsgBox.show(game.gameData.dictionary.MAGIC_MUST_PICK_ONE);
			}
		}
	}

	public function update():Void {
		PlayerDataUpdater.updateBasicData(mc.basicDataMC);
		PlayerDataUpdater.updateMoneyData(mc.moneyMC);
		PlayerDataUpdater.updateProgressData(mc.progressMC);
		setMagicBook();
	}

	function exitClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.sound.stopLoopEffects();
			game.sound.playEffect("TOWER_BACK");
			game.hideMagicBook();
		}
	}

	function setMagicBook():Void {
		//var _loc1_:Dynamic = null;
		//var _loc2_:Dynamic = null;
		//var _loc3_:Dynamic = null;
		while (mc.magicBookMC.numChildren > 0) {
			mc.magicBookMC.removeChildAt(0);
		}
		//magicBookArray = [];
		//_loc1_ = 0;
		//_loc2_ = 0;

		for (i in 0...game.gameData.magicCatalog.length) {
			var _currentMagic = game.gameData.magicCatalog[i];
			if (_currentMagic.order == game.gameData.playerData.orderCode || _currentMagic.order == game.gameData.sharedOrder ) {
				_currentMagic.init(this);
				_currentMagic.generateMC();
				mc.magicBookMC.addChild(_currentMagic.mc);
				_currentMagic.mc.x = 362 - Math.floor(i  / 6) * 362;
				_currentMagic.mc.y = i % 6 * 77;
				_currentMagic.setGraphics();
				magicBookArray.push(_currentMagic);
			}
		}
		/* while (_loc2_ < game.gameData.magicCatalog.length) {
			_loc3_ = game.gameData.magicCatalog[_loc2_];
			if (_loc3_.order == game.gameData.playerData.orderCode || _loc3_.order == game.gameData.sharedOrder) {
				_loc3_.init(this);
				_loc3_.generateMC();
				mc.magicBookMC.addChild(_loc3_.mc);
				_loc3_.mc.x = 362 - Math.floor(_loc1_ / 6) * 362;
				_loc3_.mc.y = _loc1_ % 6 * 77;
				_loc1_++;
				_loc3_.setGraphics();
				magicBookArray.push(_loc3_);
			}
			_loc2_++;
		} */
	}

	public function magicClicked(magicId:Int):Void {
		for (i in 0...magicBookArray.length) {
			magicBookArray[i].isPicked = false;
			if (magicBookArray[i].id == magicId) {
				magicBookArray[i].isPicked = true;
				currMagicId = magicId;
			}
			magicBookArray[i].setGraphics();
		}
		/* var _loc2_:Dynamic = null;
		_loc2_ = 0;
		while (_loc2_ < magicBookArray.length) {
			magicBookArray[_loc2_].isPicked = false;
			if (magicBookArray[_loc2_].id == param1) {
				magicBookArray[_loc2_].isPicked = true;
				currMagicId = param1;
			}
			magicBookArray[_loc2_].setGraphics();
			_loc2_++;
		} */
	}
}
