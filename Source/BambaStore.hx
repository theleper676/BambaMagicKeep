package;

import utils.DisplayClipComponent;
import tower_screens.StoreScreen;
import openfl.display.*;
import openfl.events.MouseEvent;
import general.ButtonUpdater;
import general.MsgBox;
import general.PlayerDataUpdater;

class BambaStore extends DisplayObject {
	public var screenType:Float;

	public var currItemPickIndex:Float;

	public var currStoreItemPickIndex:Float;

	public var mc:StoreScreen;

	public var currItemPickId:Float;

	var game:BambaMain;

	public var currStoreItemPickId:Float;

	public function new(mainGame:BambaMain) {
		//var _loc2_:MovieClip = null;
		super();
		game = mainGame;
		mc = new StoreScreen();
		//mc.orgWidth = mc.width;
		//mc.orgHeight = mc.height;
		screenType = 2;
		ButtonUpdater.setButton(mc.exitMC, closeWin);
		ButtonUpdater.setButton(mc.putOnMC, putOnItem);
		ButtonUpdater.setButton(mc.sellMC, sellItemClicked);
		ButtonUpdater.setButton(mc.buyMC, buyItemClicked);
		//_loc2_ = new MovieClip();
		//mc.itemsSP.setStyle("upSkin", _loc2_);
		//mc.storeItemsSP.setStyle("upSkin", _loc2_);
		update();
	}

	public function buyItem():Void {
		var _loc1_:Null<Dynamic> = null;
		_loc1_ = game.gameData.getCatalogItem(currStoreItemPickId);
		if (_loc1_.buyPrice <= game.gameData.playerData.money) {
			game.help.showTutorial(13);
			game.sound.playEffect("STORE_PAYMENT");
			game.gameData.playerData.addItems(Std.string(currStoreItemPickId));
			game.gameData.playerData.addMoney(-_loc1_.buyPrice);
			PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
			PlayerDataUpdater.updateMoneyData(mc.moneyMC);
		} else {
			game.sound.playEffect("GENERAL_UNAVIALABLE");
			MsgBox.show(game.gameData.dictionary.STORE_NO_MONEY);
		}
	}

	public function closeWin(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.sound.stopLoopEffects();
			game.sound.playEffect("TOWER_BACK");
			game.gameLoader.savePlayerData();
			game.hideStore();
		}
	}

	public function sellItem():Void {
		var _loc1_:Bool = false;
		var _loc2_:Null<Dynamic> = null;
		_loc1_ = game.gameData.playerData.removeItem(currItemPickId);
		if (_loc1_) {
			game.sound.playEffect("STORE_PAYMENT");
			_loc2_ = game.gameData.getCatalogItem(currItemPickId);
			game.gameData.playerData.addMoney(_loc2_.sellPrice);
			PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
			PlayerDataUpdater.updateMoneyData(mc.moneyMC);
			currItemPickId = 0;
		}
	}

	public function putOnItem(param1:MouseEvent):Void {
		var _loc2_:Null<Dynamic> = null;
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currItemPickId != 0) {
				_loc2_ = game.gameData.getCatalogItem(currItemPickId);
				if (_loc2_.minLevel <= game.gameData.playerData.level) {
					game.sound.playEffect("GENERAL_EQUIP");
					game.gameData.playerData.changeItem(currItemPickId);
					PlayerDataUpdater.setBaby(mc.babyMC, this);
					PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
					PlayerDataUpdater.updateProgressData(mc.progressMC);
					currItemPickId = 0;
				}
			} else {
				MsgBox.show(game.gameData.dictionary.STORE_MUST_PICK_ONE);
			}
		}
	}

	public function update():Void{
		setStoreItems();
		PlayerDataUpdater.setBaby(mc.babyMC, this);
		PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
		PlayerDataUpdater.updateBasicData(mc.basicDataMC);
		PlayerDataUpdater.updateProgressData(mc.progressMC);
		PlayerDataUpdater.updateMoneyData(mc.moneyMC);
		currItemPickId = 0;
		currStoreItemPickId = 0;
	}

	public function itemClickedOnBaby(param1:Dynamic):Void {
		game.gameData.playerData.removItem(param1);
		PlayerDataUpdater.setBaby(mc.babyMC, this);
		PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
		PlayerDataUpdater.updateProgressData(mc.progressMC);
	}

	public function itemClicked(param1:Dynamic, param2:Dynamic):Void {
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		currItemPickId = param1;
		currItemPickIndex = param2;
		_loc4_ = game.gameData.getCatalogItem(param1);
		_loc3_ = 0;
		while (_loc3_ < mc.itemsMC.numChildren) {
			var itemMcChild = mc.itemsMC.getChildAt(_loc3_);
			var _mc = cast(itemMcChild, MovieClip);
			var _child  = _mc.getChildAt(0);
			var _childMC = cast (_child, MovieClip);
			if (!_mc.mouseEnabled) {
				//var _child  = _mc.getChildAt(0);
				//var _childMC = cast (_child, MovieClip);
				_childMC.gotoAndStop("disable");
				//mc.itemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("disable");
			} else {
				_childMC.gotoAndStop("reg");
				//mc.itemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("reg");
			}
			if (_loc3_ == currItemPickIndex) {
				if (!_mc.mouseEnabled) {
					_childMC.gotoAndStop("disable-pick");
					//mc.itemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("disable-pick");
				} else {
					_childMC.gotoAndStop("pick");
					//mc.itemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("pick");
				}
			}
			_loc3_++;
		}
		currStoreItemPickId = 0;
		_loc3_ = 0;
		while (_loc3_ < mc.storeItemsMC.numChildren) {
			var _storeitemsMcChild = mc.storeItemsMC.getChildAt(_loc3_);
			var _mc = cast(_storeitemsMcChild, MovieClip);
			var _child  = _mc.getChildAt(0);
			var _childMC = cast (_child, MovieClip);
			if (!_mc.mouseEnabled) {
				_childMC.gotoAndStop("disable");
				//mc.storeItemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("disable");
			} else {
				_childMC.gotoAndStop("reg");
				//mc.storeItemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("reg");
			}
			_loc3_++;
		}
	}

	public function sellItemClicked(param1:MouseEvent):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currItemPickId != 0) {
				_loc2_ = game.gameData.getCatalogItem(currItemPickId);
				_loc3_ = Std.string(_loc2_.sellPrice);
				MsgBox.showYesNoBox(game.gameData.dictionary.STORE_SELL_ITEM, sellItem, null, _loc3_);
			} else {
				MsgBox.show(game.gameData.dictionary.STORE_MUST_PICK_ONE);
			}
		}
	}

	public function setStoreItems():Void {
		var _loc1_:BambaStoreItems = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:BambaItem = null;
		var _loc5_:MovieClip = null;
		while (mc.storeItemsMC.numChildren > 0) {
			mc.storeItemsMC.removeChildAt(0);
		}
		_loc1_ = game.gameData.getCatalogStoreItems(game.gameData.playerData.level, game.gameData.playerData.orderCode);
		_loc2_ = 0;
		_loc3_ = 0;
		while (_loc3_ < _loc1_.items.length) {
			_loc4_ = new BambaItem(game.gameData.getCatalogItem(_loc1_.items[_loc3_]).data);
			_loc4_.init(game);
			if (_loc4_ != null) {
				_loc4_.generateMC();
				mc.storeItemsMC.addChild(_loc4_.mc);
				_loc4_.mc.x = 216 + 10 - _loc2_ % 4 * 72;
				_loc4_.mc.y = 11 + Math.floor(_loc2_ / 4) * 52;
				_loc4_.addStoreClickEvent(this, _loc2_);
				_loc2_++;
			}
			_loc3_++;
		}
		if (_loc2_ > 32) {
			_loc5_ = new MovieClip();
			_loc5_.graphics.drawRect(0, 0, 1, 1);
			mc.storeItemsMC.addChild(_loc5_);
			_loc5_.y = Math.floor(_loc2_ / 4) * 52 + 20;
		}
		//mc.storeItemsSP.addClass(mc.storeItemsMC);
		var _current = new DisplayClipComponent(mc.storeItemsMC);
		mc.storeItemsSP.addComponent(_current);
		mc.storeItemsSP.invalidateComponentLayout();
		//mc.storeItemsSP.source = mc.storeItemsMC;
		//mc.storeItemsSP.refreshPane();
	}

	public function buyItemClicked(param1:MouseEvent):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currStoreItemPickId != 0) {
				_loc2_ = game.gameData.getCatalogItem(currStoreItemPickId);
				_loc3_ = Std.string(_loc2_.buyPrice);
				MsgBox.showYesNoBox(game.gameData.dictionary.STORE_BUY_ITEM, buyItem, null, _loc3_);
			} else {
				MsgBox.show(game.gameData.dictionary.STORE_MUST_PICK_ONE);
			}
		}
	}

	public function itemStoreClicked(pickId:Float, pickIndex:Float):Void {
		//var _loc3_:Null<Dynamic> = null;
		//var _loc4_:Null<Dynamic> = null;
		currStoreItemPickId = pickId;
		currStoreItemPickIndex = pickIndex;
		var _currentCatalogItem = game.gameData.getCatalogItem(pickId);
		currItemPickId = 0;
		//_loc3_ = 0;
		for (i in 0...mc.storeItemsMC.numChildren) {
			var _currentDisplayContainer = mc.storeItemsMC.getChildAt(i);
			var _inner = cast (_currentDisplayContainer, MovieClip);
			var _childDisplayContainer = _inner.getChildAt(0);
			var _childMC = cast (_childDisplayContainer, MovieClip);
			!_inner.mouseEnabled ? _childMC.gotoAndStop("disable") : _childMC.gotoAndStop("regular");
		}
		/* while (_loc3_ < mc.storeItemsMC.numChildren) {
			if (mc.storeItemsMC.getChildAt(_loc3_).disabled) {
				mc.storeItemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("disable");
			} else {
				mc.storeItemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("reg");
			}
			if (_loc3_ == currStoreItemPickIndex) {
				if (mc.storeItemsMC.getChildAt(_loc3_).disabled) {
					mc.storeItemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("disable-pick");
				} else {
					mc.storeItemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("pick");
				}
			}
			_loc3_++;
		} */
		
		//_loc3_ = 0;
		for (i in 0...mc.itemsMC.numChildren) {
			var _currentDisplayContainer = mc.itemsMC.getChildAt(i);
			var _inner = cast (_currentDisplayContainer, MovieClip);
			var _childDisplayContainer = _inner.getChildAt(0);
			var _childMC = cast (_childDisplayContainer, MovieClip);
			!_inner.mouseEnabled ? _childMC.gotoAndStop("disable") : _childMC.gotoAndStop("reg");
		}
		/* while (_loc3_ < mc.itemsMC.numChildren) {
			if (mc.itemsMC.getChildAt(_loc3_).disabled) {
				mc.itemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("disable");
			} else {
				mc.itemsMC.getChildAt(_loc3_).getChildAt(0).gotoAndStop("reg");
			}
			_loc3_++;
		} */
	}
}
