package;

import openfl.events.EventDispatcher;
import openfl.display.*;
import openfl.events.MouseEvent;
import general.ButtonUpdater;
import general.Heb;
import general.MsgBox;
import general.PlayerDataUpdater;
import tween.TweenLiteHaxe;
import tween.easing.*;
// import com.greensock.easing.*;

class BambaQuestManager extends EventDispatcher {
	public var currQuestDungeonId:Float;

	public var currQuestId:Float;

	public var mc:Dynamic;

	public var currSpecialEnemy:Bool;

	public var currQuestDungeonDifficulty:Float;

	var tempQuestId:Float;

	public var currMoney:Float;

	public var currMarkBoss:Bool;

	var tempQuestDungeonId:Float;

	public var currMarkAllEnemies:Bool;

	var tempQuestDungeonDifficulty:Float;

	public var currXpPoints:Float;

	var currQuest:BambaQuest;

	public var currQuestEnemyId:Float;

	var currEnemyType:Float;

	var tempQuest:BambaQuest;

	var game:BambaMain;

	var tempQuestEnemyId:Float;

	public var currSpecialTreasure:Bool;

	var tempEnemyType:Float;

	public function new(mainGame:BambaMain) {
		super();
		game = mainGame;
		mc = BambaAssets.questManagerScreen();
		mc.orgWidth = mc.width;
		mc.orgHeight = mc.height;
		mc.questMC.visible = false;
		ButtonUpdater.setButton(mc.findQuestMC, generateNewQuestClicked);
		ButtonUpdater.setButton(mc.goQuestMC, goQuestClicked);
		ButtonUpdater.setButton(mc.exitMC, exitClicked);
		currQuestId = game.gameData.playerData.currentQuestId;
		tempQuestId = currQuestId;
		update();
	}

	public function showFog():Void {
		if (tempQuestId != 0) {
			mc.crystalBallMC.gotoAndPlay("idle");
		} else {
			mc.crystalBallMC.gotoAndStop("reg");
		}
	}

	function revealQuest():Void {
		mc.questMC.alpha = 0;
		TweenLiteHaxe.to(mc.questMC, 2, {
			"alpha": 1,
			"delay": 0.5
		});
	}

	function exitClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			mc.crystalBallMC.gotoAndStop("reg");
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.sound.stopLoopEffects();
			game.sound.playEffect("TOWER_BACK");
			game.hideQuestManager();
		}
	}

	function generateNewQuest():Void {
		var _loc1_:Array<Dynamic> = null;
		var _loc2_:Array<Dynamic> = null;
		var _loc3_:Array<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Bool = false;
		var _loc6_:Null<Dynamic> = null;
		var _loc7_:Null<Dynamic> = null;
		var _loc8_:Null<Dynamic> = null;
		var _loc9_:Null<Dynamic> = null;
		var _loc10_:Null<Dynamic> = null;
		var _loc11_:Null<Dynamic> = null;
		var _loc12_:Null<Dynamic> = null;
		game.sound.playEffect("TOWER_NEW_QUEST");
		_loc1_ = [];
		_loc2_ = [];
		_loc3_ = [];
		_loc5_ = false;
		if (game.help.doShowTutorial) {
			if (game.help.currTutorialCode != 0) {
				_loc8_ = 0;
				_loc9_ = -1;
				_loc6_ = 0;
				while (_loc6_ < game.gameData.questsCatalog.length) {
					if (game.gameData.questsCatalog[_loc6_].tutorialCode <= game.help.currTutorialCode) {
						if (game.gameData.questsCatalog[_loc6_].tutorialCode > _loc8_) {
							_loc8_ = game.gameData.questsCatalog[_loc6_].tutorialCode;
							_loc9_ = _loc6_;
						}
					}
					_loc6_++;
				}
				if (_loc9_ != -1) {
					_loc10_ = game.gameData.questsCatalog[_loc9_].dungeonIds[0];
					game.gameData.questsCatalog[_loc9_].questsPossibleDungeonsIds.push(_loc10_);
					_loc1_.push(game.gameData.questsCatalog[_loc9_].id);
				}
				_loc5_ = true;
			}
		}
		if (!_loc5_) {
			_loc6_ = 0;
			while (_loc6_ < game.gameData.questsCatalog.length) {
				if (game.gameData.questsCatalog[_loc6_].tutorialCode == 0) {
					_loc11_ = false;
					_loc7_ = 0;
					while (_loc7_ < game.gameData.questsCatalog[_loc6_].dungeonIds.length) {
						_loc12_ = game.gameData.questsCatalog[_loc6_].dungeonIds[_loc7_];
						if (game.gameData.playerData.level >= game.gameData.getCatalogDungeonData(_loc12_).minLevel) {
							_loc11_ = true;
							game.gameData.questsCatalog[_loc6_].questsPossibleDungeonsIds.push(_loc12_);
						}
						_loc7_++;
					}
					if (game.gameData.playerData.level >= game.gameData.questsCatalog[_loc6_].minLevel && _loc11_) {
						_loc1_.push(game.gameData.questsCatalog[_loc6_].id);
						if (currQuestId != 0) {
							currQuest = game.gameData.getCatalogQuest(currQuestId);
							if (currQuest.type != game.gameData.questsCatalog[_loc6_].type) {
								_loc2_.push(game.gameData.questsCatalog[_loc6_].id);
								_loc4_ = false;
								_loc7_ = 0;
								while (_loc7_ < game.gameData.playerData.pastQuestsIds.length) {
									if (game.gameData.questsCatalog[_loc6_].id == game.gameData.playerData.pastQuestsIds[_loc7_]) {
										_loc4_ = true;
									}
									_loc7_++;
								}
								if (_loc4_ == false) {
									_loc3_.push(game.gameData.questsCatalog[_loc6_].id);
								}
							}
						} else {
							_loc2_.push(game.gameData.questsCatalog[_loc6_].id);
							_loc4_ = false;
							_loc7_ = 0;
							while (_loc7_ < game.gameData.playerData.pastQuestsIds.length) {
								if (game.gameData.questsCatalog[_loc6_].id == game.gameData.playerData.pastQuestsIds[_loc7_]) {
									_loc4_ = true;
								}
								_loc7_++;
							}
							if (_loc4_ == false) {
								_loc3_.push(game.gameData.questsCatalog[_loc6_].id);
							}
						}
					}
				}
				_loc6_++;
			}
		}
		if (_loc3_.length == 0) {
			if (_loc2_.length == 0) {
				tempQuestId = _loc1_[Math.floor(Math.random() * _loc1_.length)];
			} else if (_loc1_.length == 0) {
				tempQuestId = 0;
			} else {
				tempQuestId = _loc2_[Math.floor(Math.random() * _loc2_.length)];
			}
		} else {
			tempQuestId = _loc3_[Math.floor(Math.random() * _loc3_.length)];
		}
		if (tempQuestId != 0) {
			tempQuest = game.gameData.getCatalogQuest(tempQuestId);
			tempQuestDungeonId = tempQuest.questsPossibleDungeonsIds[Math.floor(Math.random() * tempQuest.questsPossibleDungeonsIds.length)];
			tempQuestDungeonDifficulty = tempQuest.dungeonDifficulties[Math.floor(Math.random() * tempQuest.dungeonDifficulties.length)];
			if (tempQuest.enemiesIds.length > 0) {
				tempQuestEnemyId = tempQuest.enemiesIds[Math.floor(Math.random() * tempQuest.enemiesIds.length)];
				tempEnemyType = 1;
				if (tempQuest.type == 2) {
					tempEnemyType = 2;
				}
			}
		}
		update();
	}

	function exitQuestMsgBox():Void {
		trace("exitQuestMsgBox");
		game.help.showTutorial(8);
		game.aDungeon.showExitSpecial();
		game.aDungeon.checkTile();
	}

	public function update():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Array<Dynamic> = null;
		currSpecialEnemy = false;
		currMarkBoss = false;
		currSpecialTreasure = false;
		currMarkAllEnemies = false;
		if (tempQuestId != 0) {
			tempQuest = game.gameData.getCatalogQuest(tempQuestId);
			if (tempQuest.type == 1) {
				currSpecialEnemy = true;
			}
			if (tempQuest.type == 2) {
				currMarkBoss = true;
			}
			if (tempQuest.type == 3) {
				currMarkAllEnemies = true;
			}
			if (tempQuest.type == 4) {
				currSpecialTreasure = true;
			}
			Heb.setText(mc.questMC.questDT, tempQuest.qDesc);
			_loc1_ = 1 + game.gameData.getCatalogPlayerLevel(game.gameData.playerData.level).missionExIncreasePrc;
			_loc2_ = 1 + game.gameData.getCatalogPlayerLevel(game.gameData.playerData.level).missionMoneyIncreasePrc;
			_loc3_ = game.gameData.getCatalogPrize(tempQuest.prizesIds[0]);
			if (Math.isNaN(tempQuestDungeonDifficulty)) {
				tempQuestDungeonDifficulty = tempQuest.dungeonDifficulties[Math.floor(Math.random() * tempQuest.dungeonDifficulties.length)];
			}
			_loc4_ = game.gameData.dungeonDifficulties[Std.int(tempQuestDungeonDifficulty - 1)][2];
			currXpPoints = Math.round(tempQuest.exPoints * _loc1_ * _loc4_ / 10) * 10;
			currMoney = Math.round(_loc3_.money * _loc2_ * _loc4_ / 10) * 10;
			Heb.setText(mc.questMC.EXPOINTS, game.gameData.dictionary.EXPOINTS + ":");
			Heb.setText(mc.questMC.xpPointsDT, Std.string(currXpPoints));
			mc.questMC.moneyIconMC.visible = true;
			Heb.setText(mc.questMC.moneyDT, Std.string(currMoney));
			_loc5_ = game.gameData.dictionary.DUNGEON_DIFFICULTIES.split(",");
			Heb.setText(mc.questMC.DUNGEON_DIFFICULTY, game.gameData.dictionary.DUNGEON_DIFFICULTY + ":");
			trace("tempQuestDungeonDifficulty:" + tempQuestDungeonDifficulty);
			mc.questMC.difficultyMC.gotoAndStop(tempQuestDungeonDifficulty + 1);
			showQuestIcon();
			mc.questMC.visible = true;
		} else {
			mc.questMC.visible = false;
			tempQuestDungeonId = 0;
			mc.questMC.questDT.text = "";
			mc.questMC.EXPOINTS.text = "";
			mc.questMC.xpPointsDT.text = "";
			mc.questMC.moneyIconMC.visible = false;
			mc.questMC.moneyDT.text = "";
			mc.questMC.DUNGEON_DIFFICULTY.text = "";
			mc.questMC.difficultyMC.gotoAndStop(1);
			hideQuestIcon();
		}
		mc.aprovedMC.gotoAndStop(1);
		if (tempQuestId == currQuestId && currQuestId != 0) {
			if (currQuestDungeonDifficulty == tempQuestDungeonDifficulty) {
				mc.aprovedMC.gotoAndStop(2);
			}
		}
		PlayerDataUpdater.updateBasicData(mc.basicDataMC);
		PlayerDataUpdater.updateMoneyData(mc.moneyMC);
		PlayerDataUpdater.updateProgressData(mc.progressMC);
	}

	function hideQuestIcon():Void {
		while (mc.questMC.questIconMC.numChildren > 0) {
			mc.questMC.questIconMC.removeChildAt(0);
		}
	}

	public function reportQuestCompleted(param1:Int):Bool {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Int = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Array<Dynamic> = null;
		_loc2_ = false;
		if (currQuestId != 0) {
			if (param1 == currQuest.type) {
				_loc3_ = 22 + param1;
				game.innerCount(_loc3_);
				game.gameData.playerData.pastQuestsIds.push(currQuestId);
				_loc4_ = currQuest.prizesIds[Math.floor(Math.random() * currQuest.prizesIds.length)];
				_loc5_ = game.gameData.playerData.addPrizes(currQuest.exPoints, _loc4_, 2);
				game.gameData.playerData.currentQuestId = 0;
				tempQuestId = 0;
				currQuestId = 0;
				currQuestDungeonId = 0;
				game.gameMap.update();
				MsgBox.showQuestBox(currQuest.endMsg, currQuest.qGraphics, _loc5_, exitQuestMsgBox);
				_loc2_ = true;
				update();
			}
		}
		return _loc2_;
	}

	function goQuestClicked(param1:MouseEvent):Void {
		var _loc2_:Int = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		if (!game.msgShown) {
			if (tempQuestId != 0) {
				if (tempQuestId != currQuestId) {
					_loc2_ = 18 + tempQuest.type;
					game.innerCount(_loc2_);
					game.sound.playEffect("TOWER_QUEST_TAKEN");
					game.sound.playEffect("GENERAL_MENU_CLICK");
					currQuestId = tempQuestId;
					currQuest = tempQuest;
					currQuestDungeonId = tempQuestDungeonId;
					currQuestDungeonDifficulty = tempQuestDungeonDifficulty;
					currQuestEnemyId = tempQuestEnemyId;
					currEnemyType = tempEnemyType;
					game.gameData.playerData.currentQuestId = currQuestId;
					game.gameData.getCatalogDungeonData(currQuestDungeonId).resetDungeon();
					_loc3_ = true;
					_loc4_ = 0;
					while (_loc4_ < game.gameData.playerData.pastDungeonsIds.length) {
						if (currQuestDungeonId == game.gameData.playerData.pastDungeonsIds[_loc4_]) {
							_loc3_ = false;
						}
						_loc4_++;
					}
					if (_loc3_) {
						game.gameData.playerData.pastDungeonsIds.push(currQuestDungeonId);
					}
					game.tower.updateQuestIcon();
					game.sound.stopLoopEffects();
					game.hideQuestManager();
				} else {
					MsgBox.show("המשימה כבר נבחרה");
				}
			} else {
				MsgBox.show("יש לבחור משימה");
			}
		}
	}

	function generateNewQuestClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			mc.crystalBallMC.gotoAndPlay("draw");
			generateNewQuest();
			revealQuest();
		}
	}

	function showQuestIcon():Void {
		var _loc1_:Null<Dynamic> = null;
		hideQuestIcon();
		_loc1_ = BambaAssets.questIcon();
		_loc1_.gotoAndStop(tempQuest.qGraphics);
		mc.questMC.questIconMC.addChild(_loc1_);
	}
}
