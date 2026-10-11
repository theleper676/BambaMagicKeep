package;

import tower_screens.CharacterScreen;
import openfl.display.*;
import openfl.events.MouseEvent;
import general.ButtonUpdater;
import general.PlayerDataUpdater;

class BambaCharacterScreen extends BambaScreen {
	public var screenType:Float;




	/**
		A typed view of `mc`, which BambaScreen has to declare as `Dynamic` because every screen
		embeds a different generated class - and which `BambaCard` relies on being Dynamic.

		Reaching through the Dynamic is what breaks: `mc.detailsMC.visible = false` resolves
		`detailsMC` fine (a real `@:keep` field) but then makes `.visible` a reflective property
		set, which hxcpp rejects once DCE has trimmed the entry - `Error : Invalid field:visible`.
		Casting once here makes every child access below a direct, typed one.
	**/
	var screen(get, never):CharacterScreen;

	inline function get_screen():CharacterScreen {
		return cast mc;
	}

	public function new(mainGame:BambaMain) {
		super(mainGame);
		mc = new CharacterScreen();
		setupButton(screen.exitMC, closeWin);
		screen.exitMC.buttonMode = true;
		screen.exitMC.tabEnabled = false;
		screenType = 1;
		update();
		/* super();
		var _loc2_:MovieClip = null;
		game = mainGame;
		mc = new CharacterScreen();
		ButtonUpdater.setButton(screen.exitMC, closeWin);
		screen.exitMC.buttonMode = true;
		screen.exitMC.tabEnabled = false;
		_loc2_ = new MovieClip();
		screen.itemsSP.setStyle("upSkin", _loc2_);
		screenType = 1;
		update(); */
	}

	/**
		Locals were Dynamic from the AS3 port, which made every `_loc3_.mc.<prop>` a reflective
		property set - rejected by hxcpp once DCE has trimmed the entry. getCatalogCard() returns
		a BambaCard whose `mc` is a typed CardBase, so naming the types makes these direct, and
		makes the missing-card case a visible skip instead of a null dereference.
	**/
	public function setCards():Void {
		var cardIds:Array<Dynamic> = cast game.gameData.playerData.cards;
		while (screen.cardsMC.numChildren > 0) {
			screen.cardsMC.removeChildAt(0);
		}
		var placed = 0;
		for (cardId in cardIds) {
			var card:BambaCard = game.gameData.getCatalogCard(cardId);
			if (card == null) {
				trace("BambaCharacterScreen: card " + cardId + " is not in the catalog");
				continue;
			}
			card.generateMC();
			if (card.mc == null) {
				trace("BambaCharacterScreen: card " + cardId + " produced no clip");
				continue;
			}
			screen.cardsMC.addChild(card.mc);
			card.addPopupEvents(this);
			card.mc.scaleX = 1;
			card.mc.scaleY = 1;
			card.mc.x = 216 - placed % 4 * 72;
			card.mc.y = Math.floor(placed / 4) * 95;
			card.mc.gotoAndStop("front");
			if (card.mc.frontMC != null) card.mc.frontMC.gotoAndStop("reg");
			card.setCardDir(-1);
			placed++;
		}
	}

	override public function update():Void {
		setCards();
		PlayerDataUpdater.setBaby(screen.babyMC, this);
		PlayerDataUpdater.setItems(screen.itemsMC, screen.itemsSP, this, screenType);
		PlayerDataUpdater.updateBasicData(screen.basicDataMC);
		PlayerDataUpdater.updateProgressData(screen.progressMC);
		PlayerDataUpdater.updateMoneyData(screen.moneyMC);
	}

	public function closeWin(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.hideCharacter();
		}
	}

	public function itemClickedOnBaby(param1:Dynamic):Void {
		game.gameData.playerData.removItem(param1);
		PlayerDataUpdater.setBaby(screen.babyMC, this);
		PlayerDataUpdater.setItems(screen.itemsMC, screen.itemsSP, this, screenType);
		PlayerDataUpdater.updateProgressData(screen.progressMC);
	}

	public function itemClicked(param1:Dynamic, param2:Dynamic):Void {
		var _loc3_:Dynamic = null;
		var _loc4_:Null<Bool> = null;
		var _loc5_:Dynamic = null;
		var _loc6_:Dynamic = null;
		_loc3_ = game.gameData.getCatalogItem(param1);
		if (_loc3_.minLevel <= game.gameData.playerData.level) {
			_loc4_ = false;
			_loc5_ = game.gameData.playerData.itemsInUse;
			_loc6_ = 0;
			while (_loc6_ < _loc5_.length) {
				if (param1 == _loc5_[_loc6_]) {
					_loc4_ = true;
				}
				_loc6_++;
			}
			if (!_loc4_) {
				game.sound.playEffect("GENERAL_EQUIP");
				game.gameData.playerData.changeItem(param1);
				PlayerDataUpdater.setBaby(screen.babyMC, this);
				PlayerDataUpdater.setItems(screen.itemsMC, screen.itemsSP, this, screenType);
				PlayerDataUpdater.updateProgressData(screen.progressMC);
			}
		}
	}
}
