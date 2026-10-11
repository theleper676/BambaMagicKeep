package;

import baby.BabyMain;
import items.ItemFrame;
import new_player.CharacterBuildScreen;
import haxe.Timer;
import openfl.display.DisplayObject;
import openfl.display.*;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.utils.*;
import general.ButtonUpdater;
import general.Heb;
import general.MsgBox;

class BambaCharacterBuildScreen extends DisplayObject {
	var babyGraphics:BabyMain;

	var line2Picks:Array<Dynamic>;

	// Typed, not Dynamic: `mc.someChild.visible = ...` through a Dynamic compiles to a
	// reflective property set, which hxcpp rejects once DCE has trimmed the entry, and a
	// missing child becomes a null dereference instead of a compile error. A real type makes
	// every child access below direct and checked.
	public var mc:CharacterBuildScreen;

	var currTabType:Float;

	var currTabIndex:Int;

	var currStage:Float;

	var game:BambaMain;

	var line1Picks:Array<Dynamic>;

	var playSlideInSoundTimer:Timer = null;
	//var playSlideInSoundInterval:Float;

	var ItemsIdPicked:Array<Dynamic>;

	var currOrder:Int;

	/**
		A child clip by name - the AS3 `clip["name"]` pattern, which a typed parent rejects.
		Tries the generated field first, then the display list.
	**/
	static function namedClip(parent:Dynamic, name:String):MovieClip {
		if (parent == null || name == null) return null;
		var found:Dynamic = Reflect.field(parent, name);
		if (found == null && Std.isOfType(parent, DisplayObjectContainer)) {
			found = (cast parent : DisplayObjectContainer).getChildByName(name);
		}
		if (found == null || !Std.isOfType(found, MovieClip)) {
			trace("BambaCharacterBuildScreen: no clip named '" + name + "'");
			return null;
		}
		return cast found;
	}

	/** `getChildAt` as a MovieClip, since getChildAt() is typed DisplayObject. **/
	static function clipAt(parent:Dynamic, index:Int):MovieClip {
		if (parent == null || !Std.isOfType(parent, DisplayObjectContainer)) return null;
		var holder:DisplayObjectContainer = cast parent;
		if (index < 0 || index >= holder.numChildren) return null;
		var found = holder.getChildAt(index);
		return Std.isOfType(found, MovieClip) ? cast found : null;
	}

	/**
		A child text field by name. `nameMC` comes through as a plain MovieClip - the exporter
		could not resolve a class for it - so its labels and the name input are not typed fields.
	**/
	static function namedText(parent:Dynamic, name:String):openfl.text.TextField {
		if (parent == null || name == null) return null;
		var found:Dynamic = Reflect.field(parent, name);
		if (found == null && Std.isOfType(parent, DisplayObjectContainer)) {
			found = (cast parent : DisplayObjectContainer).getChildByName(name);
		}
		if (found == null || !Std.isOfType(found, openfl.text.TextField)) {
			trace("BambaCharacterBuildScreen: no text field named '" + name + "'");
			return null;
		}
		return cast found;
	}

	/**
		Which order (1..3) each picker clip stands for.

		AS3 bolted `orderCode` and `isPicked` straight onto the clips at runtime. hxcpp cannot
		add fields to a typed class, so the mapping lives here instead - and `isPicked` is gone
		entirely, because `currOrder` already is that state and keeping a second copy on each
		clip only invited the two to disagree.
	**/
	var orderCodes:Map<DisplayObject, Int> = new Map();

	/** An event target as a MovieClip. **/
	static function namedClipOf(target:Dynamic):MovieClip {
		return (target != null && Std.isOfType(target, MovieClip)) ? cast target : null;
	}

	function orderCodeFor(target:Dynamic):Int {
		if (target == null || !Std.isOfType(target, DisplayObject)) return 0;
		var code = orderCodes.get(cast target);
		return code == null ? 0 : code;
	}

	public function new(mainGame:BambaMain) {
		super();
		// Typed, not Null<Dynamic>: `_loc4_.buttonMode = true` through a Dynamic is a reflective
		// property set, which hxcpp rejects once DCE has trimmed the entry.
		var _loc2_:Int = 0;
		var _loc3_:String = null;
		var _loc4_:MovieClip = null;
		var _loc5_:String = null;
		var _loc6_:String = null;
		var _loc7_:MovieClip = null;
		var _loc8_:Null<Dynamic> = null;
		game = mainGame;
		mc = new CharacterBuildScreen();
		mc.stop();
		game.gameData.playerData.resetPlayerData();
		babyGraphics = new BabyMain();
		babyGraphics.stop();
		mc.babyMC.addChild(babyGraphics);
		babyGraphics.scaleX = 1.8;
		babyGraphics.scaleY = 1.8;
		babyGraphics.x = 100;
		babyGraphics.y = 290;
		Heb.setText(mc.orderMC.CH_B_TITLE, game.gameData.dictionary.CH_B_TITLE);
		Heb.setText(mc.orderMC.CH_B_TEXT, game.gameData.dictionary.CH_B_TEXT);
		_loc2_ = 0;
		while (_loc2_ < 3) {
			_loc3_ = "order" + Std.string(_loc2_ + 1);
			_loc4_ = namedClip(mc.orderMC, _loc3_);
			if (_loc4_ == null) {
				_loc2_++;
				continue;
			}
			var orderIcon = namedClip(_loc4_, "iconMC");
			if (orderIcon != null) orderIcon.gotoAndStop(_loc2_ + 1);
			_loc5_ = game.gameData.dictionary.CH_B_OREDER_PRE + Std.string(game.gameData.dictionary.ORDERS).split(",")[_loc2_];
			var orderName = namedText(_loc4_, "ORDER_NAME");
			if (orderName != null) Heb.setText(orderName, _loc5_);
			var orderDesc = namedText(_loc4_, "ORDER_DESC");
			if (orderDesc != null) Heb.setText(orderDesc, game.gameData.dictionary.CH_B_ORDERS_DESCS.split(",")[_loc2_]);
			orderCodes.set(_loc4_, _loc2_ + 1);
			_loc4_.addEventListener(MouseEvent.CLICK, orderClicked);
			_loc4_.addEventListener(MouseEvent.ROLL_OVER, orderRollOver);
			_loc4_.addEventListener(MouseEvent.ROLL_OUT, orderRollOut);
			_loc4_.buttonMode = true;
			_loc4_.tabEnabled = false;
			_loc4_.mouseChildren = false;
			_loc2_++;
		}
		ButtonUpdater.setButton(mc.orderMC.continueMC, continueClicked);
		ButtonUpdater.setButton(mc.orderMC.backMC, backClicked);
		line1Picks = [0, 0, 0, 0, 0, 0];
		line2Picks = [0, 0, -1, -1, -1, -1];
		_loc2_ = 0;
		while (_loc2_ < 6) {
			_loc6_ = "tab" + Std.string(_loc2_ + 1);
			_loc7_ = namedClip(mc.customMC, _loc6_);
			if (_loc7_ == null) {
				_loc2_++;
				continue;
			}
			_loc7_.tabIndex = _loc2_;
			_loc8_ = game.gameData.dictionary.CH_B_TABS.split(",")[_loc2_];
			var tabName = namedText(namedClip(_loc7_, "tabNameMC"), "TAB_NAME");
			if (tabName != null) Heb.setText(tabName, _loc8_);
			_loc7_.addEventListener(MouseEvent.CLICK, tabClicked);
			_loc7_.buttonMode = true;
			_loc7_.tabEnabled = false;
			_loc2_++;
		}
		ButtonUpdater.setButton(mc.customMC.continueMC, continueClicked);
		ButtonUpdater.setButton(mc.customMC.backMC, backClicked);
		game.gameData.playerData.updateBabysLook(babyGraphics);
		Heb.setText(mc.customMC.CH_B_CUSTOM_HEAD, game.gameData.dictionary.CH_B_CUSTOM_HEAD);
		var nameTitle = namedText(mc.nameMC, "CH_B_NAME_TITLE");
		if (nameTitle != null) Heb.setText(nameTitle, game.gameData.dictionary.CH_B_NAME_TITLE);
		var nameDesc = namedText(mc.nameMC, "CH_B_NAME_DESC");
		if (nameDesc != null) Heb.setText(nameDesc, game.gameData.dictionary.CH_B_NAME_DESC);
		var nameQues = namedText(mc.nameMC, "CH_B_NAME_QUES");
		if (nameQues != null) Heb.setText(nameQues, game.gameData.dictionary.CH_B_NAME_QUES);
		var continueButton = namedClip(mc.nameMC, "continueMC");
		if (continueButton != null) ButtonUpdater.setButton(continueButton, continueClicked);
		var backButton = namedClip(mc.nameMC, "backMC");
		if (backButton != null) ButtonUpdater.setButton(backButton, backClicked);
		var nameField = namedText(mc.nameMC, "nameIT");
		if (nameField != null) nameField.addEventListener(Event.CHANGE, nameChanged);
		reset();
	}

	function orderClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			setOrder(orderCodeFor(param1.currentTarget));
		}
	}

	function backClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currStage >= 3 && currStage <= 8) {
				if (currStage == 8) {
					game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
					playSlideInSoundTimer = new Timer(600);
					playSlideInSoundTimer.run = playSlideInSound;
					//playSlideInSoundInterval = setInterval(playSlideInSound, 600);
					utils.Timeline.playSegment(mc, "nameOut");
				}
				setTab(currStage - 3);
			}
			if (currStage == 2) {
				game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
				playSlideInSoundTimer = new Timer(600);
				playSlideInSoundTimer.run = playSlideInSound;
				// playSlideInSoundInterval = setInterval(playSlideInSound, 600);
				utils.Timeline.playSegment(mc, "customOut");
			}
			if (currStage == 1) {
				game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
				playSlideInSoundTimer = new Timer(600);
				playSlideInSoundTimer.run = showMenuScreenCont;
				// playSlideInSoundInterval = setInterval(showMenuScreenCont, 600);
				utils.Timeline.playSegment(mc, "schoolOut");
			}
			--currStage;
		}
	}

	function startGameCont():Void {
		if (playSlideInSoundTimer != null) playSlideInSoundTimer.stop();
		// clearInterval(playSlideInSoundInterval);
		game.innerCount(13);
		game.startGame();
	}

	function updateSecondLine():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:BambaItem = null;
		while (mc.customMC.secondLineMC.numChildren > 0) {
			mc.customMC.secondLineMC.removeChildAt(0);
		}
		_loc1_ = true;
		switch (Std.int(currTabType)) {
			case 0:
				_loc2_ = game.gameData.characterCustomDefs[currTabIndex][2];
			case 1:
				if (line1Picks[currTabIndex] != -1) {
					_loc2_ = game.gameData.characterCustomDefs[currTabIndex][Std.int(line1Picks[currTabIndex]) + 2];
				} else {
					_loc1_ = false;
				}
			case 2:
				if (line1Picks[currTabIndex] != 0) {
					_loc2_ = game.gameData.characterCustomDefs[currTabIndex][Std.int(line1Picks[currTabIndex]) + 1];
				} else {
					_loc2_ = [];
					itemClicked(-1, 2, -1);
					_loc1_ = false;
				}
		}
		if (_loc1_) {
			_loc3_ = 0;
			_loc4_ = 0;
			while (_loc4_ < _loc2_.length) {
				_loc5_ = new BambaItem(game.gameData.getCatalogItem(_loc2_[_loc4_]).data);
				_loc5_.init(game);
				if (_loc5_ != null) {
					_loc5_.generateMC();
					mc.customMC.secondLineMC.addChild(_loc5_.mc);
					_loc5_.mc.x = 340 - _loc3_ * 85;
					_loc5_.addCharecterBuildClickEvent(this, 2, _loc3_);
					_loc3_++;
				}
				_loc4_++;
			}
			itemClicked(_loc5_.id, 2, line2Picks[currTabIndex]);
		}
	}

	function setOrder(param1:Dynamic):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		var _loc6_:Null<Dynamic> = null;
		currOrder = param1;
		_loc4_ = 0;
		while (_loc4_ < 3) {
			if (_loc4_ + 1 == param1) {
				_loc2_ = "order" + Std.string(_loc4_ + 1);
				_loc3_ = namedClip(mc.orderMC, _loc2_);
				if (_loc3_ != null) _loc3_.gotoAndStop("pick");
			} else {
				_loc2_ = "order" + Std.string(_loc4_ + 1);
				_loc3_ = namedClip(mc.orderMC, _loc2_);
				if (_loc3_ != null) _loc3_.gotoAndStop("reg");
			}
			_loc4_++;
		}
		game.gameData.playerData.resetPlayerData("", currOrder);
		game.gameData.playerData.updateBabysLook(babyGraphics);
		if (currOrder != 0) {
			_loc5_ = game.gameData.dictionary.CH_B_OREDER_PRE + Std.string(game.gameData.dictionary.ORDERS).split(",")[currOrder - 1];
			Heb.setText(mc.plateMC.orderDT, _loc5_);
			_loc6_ = "order" + currOrder;
			game.frameMC.holesMC.gotoAndStop(_loc6_);
		} else {
			mc.plateMC.orderDT.text = "";
		}
	}

	function playSlideInSound():Void {
		if (playSlideInSoundTimer != null) playSlideInSoundTimer.stop();
		// clearInterval(playSlideInSoundInterval);
		game.sound.playEffect("GENERAL_MENU_SLIDE_IN");
	}

	function tabClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			currStage = Std.int(param1.currentTarget.tabIndex) + 2;
			setTab(param1.currentTarget.tabIndex);
		}
	}

	function setTab(param1:Dynamic):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		currTabIndex = param1;
		currTabType = game.gameData.characterCustomDefs[currTabIndex][1];
		_loc2_ = 0;
		while (_loc2_ < 6) {
			_loc3_ = "tab" + Std.string(_loc2_ + 1);
			_loc4_ = namedClip(mc.customMC, _loc3_);
			if (currTabIndex == _loc2_) {
				_loc4_.gotoAndStop("pick");
			} else {
				_loc4_.gotoAndStop("reg");
			}
			_loc2_++;
		}
		setTabData();
	}

	function showMenuScreenCont():Void {
		if (playSlideInSoundTimer != null) playSlideInSoundTimer.stop();
		// clearInterval(playSlideInSoundInterval);
		game.showMenuScreen();
	}

	function itemClicked(param1:Dynamic, param2:Dynamic, param3:Dynamic):Void {
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		var _loc6_:Null<Dynamic> = null;
		var _loc7_:Null<Dynamic> = null;
		if (param3 != -1) {
			_loc5_ = game.gameData.getCatalogItem(param1);
			if (param2 == 1) {
				line1Picks[currTabIndex] = param3;
				_loc6_ = 0;
				if (currTabType == 2) {
					var firstChild = clipAt(mc.customMC.firstLineMC, 0);
					if (firstChild != null) firstChild.gotoAndStop("empty");
					if (param3 == 0) {
						var pickChild = clipAt(mc.customMC.firstLineMC, 0);
						if (pickChild != null) pickChild.gotoAndStop("empty-pick");
					}
					_loc6_++;
				}
				_loc4_ = _loc6_;
				while (_loc4_ < mc.customMC.firstLineMC.numChildren) {
					var firstInner = clipAt(clipAt(mc.customMC.firstLineMC, _loc4_), 0);
					if (firstInner != null) firstInner.gotoAndStop("reg");
					if (_loc4_ == param3) {
						var firstPick = clipAt(clipAt(mc.customMC.firstLineMC, _loc4_), 0);
						if (firstPick != null) firstPick.gotoAndStop("pick");
					}
					_loc4_++;
				}
				_loc7_ = true;
				if (currTabType == 1 || currTabType == 2) {
					if (line2Picks[currTabIndex] == -1) {
						if (currTabType == 2 && line1Picks[currTabIndex] == 0) {
							line2Picks[currTabIndex] = -1;
						} else {
							line2Picks[currTabIndex] = 0;
						}
					}
					_loc7_ = false;
					updateSecondLine();
				}
				if (_loc7_) {
					ItemsIdPicked = getItemPicked();
					game.gameData.playerData.resetPlayerData("", currOrder, ItemsIdPicked);
					game.gameData.playerData.updateBabysLook(babyGraphics);
				}
			}
			if (param2 == 2) {
				line2Picks[currTabIndex] = -1;
				_loc4_ = 0;
				while (_loc4_ < mc.customMC.secondLineMC.numChildren) {
					var secondInner = clipAt(clipAt(mc.customMC.secondLineMC, _loc4_), 0);
					if (secondInner != null) secondInner.gotoAndStop("reg");
					if (_loc4_ == param3) {
						var secondPick = clipAt(clipAt(mc.customMC.secondLineMC, _loc4_), 0);
						if (secondPick != null) secondPick.gotoAndStop("pick");
						line2Picks[currTabIndex] = param3;
					}
					_loc4_++;
				}
				ItemsIdPicked = getItemPicked();
				game.gameData.playerData.resetPlayerData("", currOrder, ItemsIdPicked);
				game.gameData.playerData.updateBabysLook(babyGraphics);
			}
		} else if (currTabType == 2 && param2 == 2) {
			line2Picks[currTabIndex] = param3;
			ItemsIdPicked = getItemPicked();
			game.gameData.playerData.resetPlayerData("", currOrder, ItemsIdPicked);
			game.gameData.playerData.updateBabysLook(babyGraphics);
		}
	}

	function orderRollOver(param1:MouseEvent):Void {
		if (!game.msgShown) {
			var hovered = namedClipOf(param1.currentTarget);
			if (hovered != null && orderCodeFor(param1.currentTarget) != currOrder) {
				hovered.gotoAndStop("rollover");
			}
		}
	}

	function emptyFramePicked():Void {
		itemClicked(-1, 1, 0);
	}

	function orderRollOut(param1:MouseEvent):Void {
		if (!game.msgShown) {
			var hovered = namedClipOf(param1.currentTarget);
			if (hovered != null && orderCodeFor(param1.currentTarget) != currOrder) {
				hovered.gotoAndStop("reg");
			}
		}
	}

	function getItemPicked():Dynamic {
		var _loc1_:Array<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		_loc1_ = [];
		_loc3_ = 0;
		while (_loc3_ < 6) {
			_loc4_ = game.gameData.characterCustomDefs[_loc3_][1];
			if (_loc4_ == 0) {
				if (line1Picks[_loc3_] != -1) {
					_loc2_ = game.gameData.characterCustomDefs[_loc3_][0][line1Picks[_loc3_]];
					_loc1_.push(_loc2_);
				}
				if (line2Picks[_loc3_] != -1) {
					_loc2_ = game.gameData.characterCustomDefs[_loc3_][2][line2Picks[_loc3_]];
					_loc1_.push(_loc2_);
				}
			} else if (_loc4_ == 1) {
				if (line2Picks[_loc3_] != -1) {
					_loc2_ = game.gameData.characterCustomDefs[_loc3_][Std.int(line1Picks[_loc3_]) + 2][line2Picks[_loc3_]];
					_loc1_.push(_loc2_);
				}
			} else if (line2Picks[_loc3_] != -1) {
				_loc2_ = game.gameData.characterCustomDefs[_loc3_][Std.int(line1Picks[_loc3_]) + 1][line2Picks[_loc3_]];
				_loc1_.push(_loc2_);
			}
			_loc3_++;
		}
		return _loc1_;
	}

	function continueClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (currStage == 1) {
				if (currOrder == 0) {
					MsgBox.show(game.gameData.dictionary.CH_B_NO_ORDER);
					return;
				}
				game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
				playSlideInSoundTimer = new Timer(600);
				playSlideInSoundTimer.run = playSlideInSound;
				// playSlideInSoundInterval = setInterval(playSlideInSound, 600);
				utils.Timeline.playSegment(mc, "customIn");
			}
			if (currStage >= 1 && currStage <= 6) {
				setTab(currStage - 1);
			}
			if (currStage == 7) {
				game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
				playSlideInSoundTimer = new Timer(600);
				playSlideInSoundTimer.run = playSlideInSound;
				// playSlideInSoundInterval = setInterval(playSlideInSound, 600);
				utils.Timeline.playSegment(mc, "nameIn");
			}
			if (currStage == 8) {
				var nameInput = namedText(mc.nameMC, "nameIT");
				var typedName = nameInput != null ? nameInput.text : "";
				if (typedName.length < 3) {
					MsgBox.show(game.gameData.dictionary.CH_B_MIN_NAME);
					return;
				}
				game.gameData.playerData.resetPlayerData(typedName, currOrder, ItemsIdPicked);
				game.didLogin = true;
				game.gameLoader.savePlayerData();
				game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
				playSlideInSoundTimer = new Timer(600);
				playSlideInSoundTimer.run = startGameCont;
				// playSlideInSoundInterval = setInterval(statGameCont, 600);
				utils.Timeline.playSegment(mc, "nameOutEnd");
				return;
			}
			++currStage;
		}
	}

	function emptyFrameClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			emptyFramePicked();
		}
	}

	function nameChanged(param1:Event):Void {
		var nameField = namedText(mc.nameMC, "nameIT");
		if (nameField != null) Heb.setText(mc.plateMC.nameDT, nameField.text);
	}

	public function reset():Void {
		currStage = 1;
		line1Picks = [0, 0, 0, 0, 0, 0];
		line2Picks = [0, 0, -1, -1, -1, -1];
		var nameToClear = namedText(mc.nameMC, "nameIT");
		if (nameToClear != null) nameToClear.text = "";
		mc.plateMC.nameDT.text = "";
		setOrder(0);
		setTab(0);
	}

	public function slideIn():Void {
		game.sound.playEffect("GENERAL_MENU_SLIDE_IN");
		utils.Timeline.playSegment(mc, "schoolIn");
	}

	function setTabData():Void {
		final ITEM_X_LOCATION = 350;
		//var _loc1_:Null<Dynamic> = null;
		//var _loc2_:Null<Dynamic> = null;
		//var _loc3_:Null<Dynamic> = null;
		//var _loc4_:Null<Dynamic> = null;
		//var _loc5_:Null<Dynamic> = null;
		var _loc6_:Null<Dynamic> = null;
		//var _loc7_:Null<Dynamic> = null;
		var _item:Null<BambaItem> = null;
		var _chBFirstLine = game.gameData.dictionary.CH_B_FIRST_LINE.split(",")[currTabIndex];
		var _chBSecondLine = game.gameData.dictionary.CH_B_SECOND_LINE.split(",")[currTabIndex];
		Heb.setText(mc.customMC.CH_B_FIRST_LINE, _chBFirstLine);
		Heb.setText(mc.customMC.CH_B_SECOND_LINE, _chBSecondLine);
		var _currentCustomDef:Array<Dynamic> = game.gameData.characterCustomDefs[currTabIndex][0];
		while (mc.customMC.firstLineMC.numChildren > 0) {
			mc.customMC.firstLineMC.removeChildAt(0);
		}
		var _tabIndex:Int = 0;
		if (currTabType == 2) {
			var _itemFrame = new ItemFrame();
			mc.customMC.firstLineMC.addChild(_itemFrame);
			_itemFrame.x = ITEM_X_LOCATION;
			_itemFrame.addEventListener(MouseEvent.CLICK, emptyFrameClicked);
			_itemFrame.buttonMode = true;
			_itemFrame.tabEnabled = false;
			_itemFrame.gotoAndStop("empty-pick");
			_tabIndex++;
		}
		_loc6_ = 0;
		for (i in 0..._currentCustomDef.length) {
			_item = new BambaItem(game.gameData.getCatalogItem(_currentCustomDef[i]).data);
			_item.init(game);
			if (_item != null) {
				_item.generateMC();
				mc.customMC.firstLineMC.addChild(_item.mc);
				_item.mc.x = ITEM_X_LOCATION - _tabIndex * 85;
				_item.addCharecterBuildClickEvent(this, 1, _tabIndex);
				_tabIndex++;
			}
		}
		/* while (_loc6_ < _loc3_.length) {
			_loc8_ = new BambaItem(game.gameData.getCatalogItem(_loc3_[_loc6_]).data);
			_loc8_.init(game);
			if (_loc8_ != null) {
				_loc8_.generateMC();
				mc.customMC.firstLineMC.addChild(_loc8_.mc);
				_loc8_.mc.x = ITEM_X_LOCATION - _loc4_ * 85;
				_loc8_.addCharecterBuildClickEvent(this, 1, _loc4_);
				_loc4_++;
			}
			_loc6_++;
		} */
		itemClicked(_item.id, 1, line1Picks[currTabIndex]);
		if (currTabType == 2) {
			if (line1Picks[currTabIndex] == 0) {
				emptyFramePicked();
			}
		} else {
			updateSecondLine();
		}
	}
}
