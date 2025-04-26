package;

import cards.CardBase;
import tower_screens.CardsUpgradeScreen;
import openfl.display.*;
import openfl.events.MouseEvent;
import general.ButtonUpdater;
import general.Heb;
import general.MsgBox;
import general.PlayerDataUpdater;

class BambaUpgradeSystem extends BambaScreen {
	var cardsArray:Array<BambaCard>;

	var currCardId:Float;

	public function new(mainGame:BambaMain) {
		super(mainGame);
		
		mc = new CardsUpgradeScreen();
		//mc.orgWidth = mc.width;
		//mc.orgHeight = mc.height;
		ButtonUpdater.setButton(mc.upgradeMC, upgradeClicked);
		ButtonUpdater.setButton(mc.exitMC, exitClicked);
		cardsArray = [];
		update();
	}

	function setCards():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		currCardId = 0;
		//cardsArray = [];
		_loc3_ = game.gameData.playerData.cards;
		_loc4_ = true;
		while (mc.cardsMC.numChildren > 0) {
			mc.cardsMC.removeChildAt(0);
		}
		_loc5_ = 0;
		_loc1_ = 0;
		while (_loc1_ < _loc3_.length) {
			_loc2_ = game.gameData.getNewCard(_loc3_[_loc1_]);
			if (_loc2_.upgradeTo != 0) {
				_loc2_.generateMC();
				_loc2_.mc.scaleX = 1;
				_loc2_.mc.scaleY = 1;
				mc.cardsMC.addChild(_loc2_.mc);
				_loc2_.mc.x = 225 - _loc5_ % 4 * 75;
				_loc2_.mc.y = Math.floor(_loc5_ / 4) * 105;
				_loc2_.setCardDir(-1);
				if (_loc2_.upgradeTo > 0) {
					_loc2_.mc.frontMC.gotoAndStop("reg");
					_loc2_.setCardforUpgrade(this);
					cardsArray.push(_loc2_);
				} else {
					_loc2_.mc.frontMC.gotoAndStop("disable");
				}
				_loc5_++;
			}
			_loc1_++;
		}
	}

	override public function update():Void {
		PlayerDataUpdater.updateBasicData(mc.basicDataMC);
		PlayerDataUpdater.updateMoneyData(mc.moneyMC);
		PlayerDataUpdater.updateProgressData(mc.progressMC);
		mc.detailsMC.visible = false;
		setCards();
	}

	function upgradeClicked(param1:MouseEvent):Void {
		var _loc2_:BambaCard = null;
		var _loc3_:BambaCard = null;
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currCardId != 0) {
				_loc2_ = game.gameData.getCatalogCard(currCardId);
				if (_loc2_.upgradeTo == 0) {
					MsgBox.show(game.gameData.dictionary.UPGRADE_CANT_UPGRADE_CARD);
				} else {
					_loc3_ = game.gameData.getCatalogCard(_loc2_.upgradeTo);
					if (_loc3_.minLevel > game.gameData.playerData.level) {
						game.sound.playEffect("GENERAL_UNAVIALABLE");
						MsgBox.show(game.gameData.dictionary.UPGRADE_LEVEL_TO_LOW);
					} else if (game.gameData.playerData.ingredient1 >= _loc2_.ingredient1
						&& game.gameData.playerData.ingredient2 >= _loc2_.ingredient2
						&& game.gameData.playerData.ingredient3 >= _loc2_.ingredient3
						&& game.gameData.playerData.ingredient4 >= _loc2_.ingredient4) {
						game.help.showTutorial(23);
						game.help.finishTutorial();
						game.sound.playEffect("TOWER_MAGIC_UPGRADE");
						game.gameData.playerData.upgradeCard(_loc2_.id, _loc2_.upgradeTo);
						game.gameData.playerData.addIngredients(-_loc2_.ingredient1, -_loc2_.ingredient2, -_loc2_.ingredient3, -_loc2_.ingredient4);
						PlayerDataUpdater.updateMoneyData(mc.moneyMC);
						game.gameLoader.savePlayerData();
						setCards();
						clearDetails();
					} else {
						game.sound.playEffect("GENERAL_UNAVIALABLE");
						MsgBox.show(game.gameData.dictionary.UPGRADE_NO_INGREDIENTS);
					}
				}
			} else {
				MsgBox.show(game.gameData.dictionary.UPGRADE_MUST_PICK_ONE);
			}
		}
	}

	override public function cardRollOver(id:Float): Void {
		var _currentCard = game.gameData.getCatalogCard(id);
		if (_currentCard.upgradeTo != 0) {
			mc.detailsMC.visible = true;
			var _upgradeToCard = game.gameData.getCatalogCard(_currentCard.upgradeTo);
			Heb.setText(mc.detailsMC.nameDT, _upgradeToCard.cName);
			Heb.setText(mc.detailsMC.descDT, _currentCard.upgradeDesc);
			mc.detailsMC.minLevelDT.text = Std.string(_upgradeToCard.minLevel);
			mc.detailsMC.ingredient1DT.text = Std.string(_currentCard.ingredient1);
			mc.detailsMC.ingredient2DT.text = Std.string(_currentCard.ingredient2);
			mc.detailsMC.ingredient3DT.text = Std.string(_currentCard.ingredient3);
			mc.detailsMC.ingredient4DT.text = Std.string(_currentCard.ingredient4);
			while (mc.detailsMC.newCardMC.numChildren > 0) {
				mc.detailsMC.newCardMC.removeChildAt(0);
			}
			trace("not generating card mc, needs to fix");
			_upgradeToCard.generateMC(-1);
			_upgradeToCard.mc.gotoAndStop(1);
			mc.detailsMC.newCardMC.addChild(_upgradeToCard.mc);
		} else {
			clearDetails();
		}
	}

	function clearDetails():Void {
		mc.detailsMC.visible = false;
	}

	override public function cardClicked(param1:Dynamic):Void {
		var _loc2_:Null<Dynamic> = null;
		_loc2_ = 0;
		while (_loc2_ < cardsArray.length) {
			cardsArray[_loc2_].mc.frontMC.gotoAndStop("reg");
			if (cardsArray[_loc2_].id == param1) {
				cardsArray[_loc2_].mc.frontMC.gotoAndStop("frame");
				currCardId = param1;
			}
			_loc2_++;
		}
	}

	function exitClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.sound.stopLoopEffects();
			game.sound.playEffect("TOWER_BACK");
			game.hideUpgradeCrads();
		}
	}
}
