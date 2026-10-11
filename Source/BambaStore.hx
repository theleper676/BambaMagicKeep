package;

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
		//var skin = new MovieClip();
		//mc.itemsSP.setStyle("upSkin", skin);
		//mc.storeItemsSP.setStyle("upSkin", skin);
		update();
	}

	public function buyItem():Void {
		var item = game.gameData.getCatalogItem(currStoreItemPickId);
		if (item.buyPrice <= game.gameData.playerData.money) {
			game.help.showTutorial(13);
			game.sound.playEffect("STORE_PAYMENT");
			game.gameData.playerData.addItems(Std.string(currStoreItemPickId));
			game.gameData.playerData.addMoney(-item.buyPrice);
			PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
			PlayerDataUpdater.updateMoneyData(mc.moneyMC);
		} else {
			game.sound.playEffect("GENERAL_UNAVIALABLE");
			MsgBox.show(game.gameData.dictionary.STORE_NO_MONEY);
		}
	}

	public function closeWin(event:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.sound.stopLoopEffects();
			game.sound.playEffect("TOWER_BACK");
			game.gameLoader.savePlayerData();
			game.hideStore();
		}
	}

	public function sellItem():Void {
		var removed = game.gameData.playerData.removeItem(currItemPickId);
		if (removed) {
			game.sound.playEffect("STORE_PAYMENT");
			var item = game.gameData.getCatalogItem(currItemPickId);
			game.gameData.playerData.addMoney(item.sellPrice);
			PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
			PlayerDataUpdater.updateMoneyData(mc.moneyMC);
			currItemPickId = 0;
		}
	}

	public function putOnItem(event:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currItemPickId != 0) {
				var item = game.gameData.getCatalogItem(currItemPickId);
				if (item.minLevel <= game.gameData.playerData.level) {
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

	public function update():Void {
		setStoreItems();
		PlayerDataUpdater.setBaby(mc.babyMC, this);
		PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
		PlayerDataUpdater.updateBasicData(mc.basicDataMC);
		PlayerDataUpdater.updateProgressData(mc.progressMC);
		PlayerDataUpdater.updateMoneyData(mc.moneyMC);
		currItemPickId = 0;
		currStoreItemPickId = 0;
	}

	public function itemClickedOnBaby(itemId:Dynamic):Void {
		game.gameData.playerData.removItem(itemId);
		PlayerDataUpdater.setBaby(mc.babyMC, this);
		PlayerDataUpdater.setItems(mc.itemsMC, mc.itemsSP, this, screenType);
		PlayerDataUpdater.updateProgressData(mc.progressMC);
	}

	public function itemClicked(pickId:Dynamic, pickIndex:Dynamic):Void {
		currItemPickId = pickId;
		currItemPickIndex = pickIndex;
		var i = 0;
		while (i < mc.itemsMC.numChildren) {
			var ownedItem = cast(mc.itemsMC.getChildAt(i), MovieClip);
			// The scroll spacer PlayerDataUpdater.setItems appends is an empty MovieClip.
			if (ownedItem == null || ownedItem.numChildren == 0) { i++; continue; }
			var ownedFrame = cast(ownedItem.getChildAt(0), MovieClip);
			if (!ownedItem.mouseEnabled) {
				ownedFrame.gotoAndStop("disable");
			} else {
				ownedFrame.gotoAndStop("reg");
			}
			if (i == currItemPickIndex) {
				if (!ownedItem.mouseEnabled) {
					ownedFrame.gotoAndStop("disable-pick");
				} else {
					ownedFrame.gotoAndStop("pick");
				}
			}
			i++;
		}
		currStoreItemPickId = 0;
		i = 0;
		while (i < mc.storeItemsMC.numChildren) {
			var storeItem = cast(mc.storeItemsMC.getChildAt(i), MovieClip);
			// Skip the scroll spacer BambaStore.setStoreItems adds past 32 items.
			if (storeItem == null || storeItem.numChildren == 0) { i++; continue; }
			var storeFrame = cast(storeItem.getChildAt(0), MovieClip);
			if (!storeItem.mouseEnabled) {
				storeFrame.gotoAndStop("disable");
			} else {
				storeFrame.gotoAndStop("reg");
			}
			i++;
		}
	}

	public function sellItemClicked(event:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currItemPickId != 0) {
				var item = game.gameData.getCatalogItem(currItemPickId);
				var priceText = Std.string(item.sellPrice);
				MsgBox.showYesNoBox(game.gameData.dictionary.STORE_SELL_ITEM, sellItem, null, priceText);
			} else {
				MsgBox.show(game.gameData.dictionary.STORE_MUST_PICK_ONE);
			}
		}
	}

	public function setStoreItems():Void {
		while (mc.storeItemsMC.numChildren > 0) {
			mc.storeItemsMC.removeChildAt(0);
		}
		var storeItems = game.gameData.getCatalogStoreItems(game.gameData.playerData.level, game.gameData.playerData.orderCode);
		var placed = 0;
		var i = 0;
		while (i < storeItems.items.length) {
			var item = new BambaItem(game.gameData.getCatalogItem(storeItems.items[i]).data);
			item.init(game);
			if (item != null) {
				item.generateMC();
				mc.storeItemsMC.addChild(item.mc);
				item.mc.x = 216 + 10 - placed % 4 * 72;
				item.mc.y = 11 + Math.floor(placed / 4) * 52;
				item.addStoreClickEvent(this, placed);
				placed++;
			}
			i++;
		}
		if (placed > 32) {
			var spacer = new MovieClip();
			spacer.graphics.drawRect(0, 0, 1, 1);
			mc.storeItemsMC.addChild(spacer);
			spacer.y = Math.floor(placed / 4) * 52 + 20;
		}
		// storeItemsSP's rectangle on the store screen (the ScrollPane's matrix in the SWF).
		utils.ClipScroller.of(mc, mc.storeItemsMC, mc.storeItemsSP, new openfl.geom.Rectangle(19, 67, 310, 425)).refresh();
	}

	public function buyItemClicked(event:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currStoreItemPickId != 0) {
				var item = game.gameData.getCatalogItem(currStoreItemPickId);
				var priceText = Std.string(item.buyPrice);
				MsgBox.showYesNoBox(game.gameData.dictionary.STORE_BUY_ITEM, buyItem, null, priceText);
			} else {
				MsgBox.show(game.gameData.dictionary.STORE_MUST_PICK_ONE);
			}
		}
	}

	public function itemStoreClicked(pickId:Float, pickIndex:Float):Void {
		currStoreItemPickId = pickId;
		currStoreItemPickIndex = pickIndex;
		currItemPickId = 0;
		for (i in 0...mc.storeItemsMC.numChildren) {
			var storeItem = cast(mc.storeItemsMC.getChildAt(i), MovieClip);
			// Skip the scroll spacer that setStoreItems adds past 32 items - it has no children.
			if (storeItem == null || storeItem.numChildren == 0) continue;
			var storeFrame = cast(storeItem.getChildAt(0), MovieClip);
			!storeItem.mouseEnabled ? storeFrame.gotoAndStop("disable") : storeFrame.gotoAndStop("regular");
		}
		for (i in 0...mc.itemsMC.numChildren) {
			var ownedItem = cast(mc.itemsMC.getChildAt(i), MovieClip);
			// Skip the scroll spacer PlayerDataUpdater.setItems adds past 24 items.
			if (ownedItem == null || ownedItem.numChildren == 0) continue;
			var ownedFrame = cast(ownedItem.getChildAt(0), MovieClip);
			!ownedItem.mouseEnabled ? ownedFrame.gotoAndStop("disable") : ownedFrame.gotoAndStop("reg");
		}
	}
}
