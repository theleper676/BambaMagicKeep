package;

import haxe.Timer;
import openfl.display.*;
import openfl.events.MouseEvent;
import openfl.geom.ColorTransform;
import openfl.utils.*;
import general.ButtonUpdater;
import general.Heb;
import general.MsgBox;
import tween.TweenLiteHaxe;
import com.greensock.easing.*;

class BambaFight extends DisplayObject {
	var roundCardsIds:Array<Dynamic>;

	public var enemy:BambaFighter;

	var cardFightLocationAndSize:Dynamic;

	var nextStepContinueIntervalTimer: Timer;
	//var nextStepContinueInterval:Dynamic;

	public var MC:Dynamic;

	var cardPicksLocation:Array<Array<Int>>;

	public var me:BambaFighter;

	public var currStep:Float;

	var roundNum:Float;

	var fightStatus:Float;

	var cardUnPicksAttackLocation:Dynamic;

	public var enemyLevelData:BambaEnemyLevel;

	var hitMatrix:Dynamic;

	var animCardIntervalTimer:Timer;
	// var animCardInterval:Dynamic;

	var costOfPickedCards:Float;

	var enemyId:Float;

	var fightStage:Float;

	public var enemyData:BambaEnemy;

	var cardsPlayerCanUse:Dynamic;

	public var cardsEnemyCanUse:Dynamic;

	var noLife:Float;

	var enemyType:Float;

	var enemyLevel:Int;

	var cardPickedByPlayer:Array<Dynamic>;

	var endAnimIntervalTimer: Timer;
	//var endAnimInterval:Dynamic;

	public var game:BambaMain;

	public var roundCards:Array<Dynamic>;

	var cardUnPicksMoveLocation:Dynamic;

	var startAnimIntervalTimer:Timer;
	// var startAnimInterval:Dynamic;
	var winAnimIntervalTimer:Timer;
	//var winAnimInterval:Dynamic;

	public function new(game:BambaMain, param2:Dynamic, param3:Dynamic, param4:Dynamic, param5:Dynamic) {
		var _loc6_:Null<Dynamic> = null;
		cardPicksLocation = [[140, 0], [70, 0], [0, 0]];
		cardUnPicksMoveLocation = [[513, 0], [427.5, 0], [342, 0], [256.5, 0], [171, 0], [85.5, 0], [0, 0]];
		cardUnPicksAttackLocation = [
			[427.5, 100],
			[342, 100],
			[256.5, 100],
			[171, 100],
			[85.5, 100],
			[427.5, 200],
			[342, 200],
			[256.5, 200],
			[171, 200],
			[85.5, 200]
		];
		cardFightLocationAndSize = [
			[176, 0, 1],
			[252, 18, 0.63],
			[301, 18, 0.63],
			[98, 0, 1],
			[49, 18, 0.63],
			[0, 18, 0.63]
		];
		super();
		this.game = game;
		MC = param2;
		enemyId = param3;
		enemyType = param4;
		enemyLevel = param5;
		enemyData = game.gameData.getCatalogEnemy(enemyId, enemyType);
		enemyLevelData = game.gameData.getCatalogEnemyLevel(enemyLevel, enemyType);
		ButtonUpdater.setButton(MC.cardPickMC.fightButton, fightButtonClicked);
		ButtonUpdater.setButton(MC.continueButtonParent.continueButton, continueButtonClicked);
		MC.cardPickMC.visible = true;
		MC.boardMC.visible = false;
		MC.continueButtonParent.visible = false;
		_loc6_ = BambaAssets.fightBack;
		MC.boardMC.backMC.addChild(_loc6_);
		Heb.setText(MC.meData.LIFE, game.gameData.dictionary.LIFE);
		Heb.setText(MC.meData.MAGIC, game.gameData.dictionary.MAGIC);
		Heb.setText(MC.meData.NAME, game.gameData.playerData.pName
			+ " "
			+ game.gameData.dictionary.CHARACTER_LEVEL
			+ " "
			+ game.gameData.playerData.level);
		Heb.setText(MC.enemyData.LIFE, game.gameData.dictionary.LIFE);
		Heb.setText(MC.enemyData.MAGIC, game.gameData.dictionary.MAGIC);
		Heb.setText(MC.enemyData.NAME, enemyData.eName + " " + game.gameData.dictionary.CHARACTER_LEVEL + " " + enemyLevel);
		setFighters();
		resetFight();
	}

	function afterEndFight():Void {
		var _loc1_:String = null;
		var _loc2_:Array<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Array<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		var _loc6_:Null<Dynamic> = null;
		endAnimIntervalTimer.stop();
		// clearInterval(endAnimInterval);
		if (fightStatus == 2) {
			_loc3_ = 1;
			_loc4_ = enemyData.prizesIds;
			_loc5_ = _loc4_[Math.floor(Math.random() * _loc4_.length)];
			_loc2_ = game.gameData.playerData.addPrizes(enemyLevelData.exPoints, _loc5_, _loc3_);
			_loc6_ = 2;
			MsgBox.showWin(game.gameData.dictionary.WIN_FIGHT_MSG, _loc2_, closeMsgBox, _loc6_);
		} else {
			game.aDungeon.endFight(fightStatus);
		}
	}

	public function startRoundAnim():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		MC.cardPickMC.visible = false;
		MC.boardMC.visible = true;
		roundCards = [];
		_loc1_ = 0;
		while (_loc1_ < 6) {
			_loc2_ = game.gameData.getNewCard(roundCardsIds[_loc1_]);
			roundCards.push(_loc2_);
			if (_loc1_ < 3) {
				_loc2_.generateMC(me.dir);
			} else {
				_loc2_.generateMC(enemy.dir);
			}
			MC.cardsFightMC.addChild(_loc2_.mc);
			_loc2_.mc.gotoAndStop("back");
			_loc2_.mc.scaleX = cardFightLocationAndSize[_loc1_][2];
			_loc2_.mc.scaleY = cardFightLocationAndSize[_loc1_][2];
			_loc2_.mc.x = cardFightLocationAndSize[_loc1_][0];
			_loc2_.mc.y = cardFightLocationAndSize[_loc1_][1];
			_loc1_++;
		}
		++roundNum;
		currStep = 0;
		playStep();
	}

	function showContinueAtStart():Void {
		trace("showContinueAtStart");
		startAnimIntervalTimer.stop();
		// clearInterval(startAnimInterval);
		MC.continueButtonParent.visible = true;
		MC.continueButtonParent.gotoAndPlay("up");
	}

	public function resetFight():Void {
		resetFightVars();
		if (me != null) {
			me.initFighter();
			enemy.initFighter();
		}
		startFight();
	}

	public function disableExpensiveCards():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		_loc1_ = 0;
		while (_loc1_ < cardsPlayerCanUse.length) {
			_loc2_ = game.gameData.getCatalogCard(cardsPlayerCanUse[_loc1_]);
			if (_loc2_.picked == false) {
				if (_loc2_.cost > me.magicPower - costOfPickedCards) {
					_loc2_.mc.frontMC.gotoAndStop("disable");
					_loc2_.disabled = true;
				} else {
					_loc2_.mc.frontMC.gotoAndStop("reg");
					_loc2_.disabled = false;
				}
			}
			_loc1_++;
		}
	}

	public function hideHitMatrix():Void {
		if (MC.boardMC.backMC.contains(hitMatrix)) {
			MC.boardMC.backMC.removeChild(hitMatrix);
		}
	}

	public function playStep():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_: Null<Dynamic> = null;
		_loc1_ = Math.floor(currStep / 2);
		_loc2_ = currStep % 2;
		if (_loc2_ == 0) {
			animCards();
		} else {
			playCardinStep();
		}
	}

	function closeMsgBox():Void {
		var _loc1_:Null<Dynamic> = null;
		if (roundCards != null) {
			_loc1_ = 0;
			while (_loc1_ < roundCards.length) {
				if (MC.contains(roundCards[_loc1_].mc)) {
					MC.cardsFightMC.removeChild(roundCards[_loc1_].mc);
				}
				_loc1_++;
			}
		}
		if (game.aDungeon != null) {
			game.aDungeon.endFight(fightStatus);
		}
	}

	public function reportNoLife(param1:Dynamic):Void {
		if (noLife != 0) {
			noLife = 4;
		} else {
			noLife = param1;
		}
	}

	function playWinAnim(param1:BambaFighter):Void {
		winAnimIntervalTimer.stop();
		//clearInterval(winAnimInterval);
		param1.playWinAnim();
	}

	function endFight(param1:Dynamic):Void {
		if (fightStatus == 1) {
			fightStatus = param1;
			switch (fightStatus) {
				case 2:
					game.sound.playEffect("BATTLE_WIN");
					game.sound.stopMusic();
					winAnimIntervalTimer = new Timer(500);
					winAnimIntervalTimer.run = function () {
						playWinAnim(me);
					}
					enemy.playLoseAnim();
					
				case 3:
					game.sound.playEffect("BATTLE_LOSE");
					game.sound.stopMusic();
					winAnimIntervalTimer = new Timer(500);
					winAnimIntervalTimer.run = function () {
						playWinAnim(enemy);
					}
					//winAnimInterval = setInterval(playWinAnim, 500, enemy);
					me.playLoseAnim();
				case 4:
					game.sound.playEffect("BATTLE_LOSE");
					game.sound.stopMusic();
					enemy.playLoseAnim();
					me.playLoseAnim();
			}
			endAnimIntervalTimer = new Timer(game.gameData.winAnimLength * 1000);
			endAnimIntervalTimer.run = afterEndFight;
			//endAnimInterval = setInterval(afterEndFight, game.gameData.winAnimLength * 1000);
		}
	}

	function continueButtonClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			setCardPick();
			MC.continueButtonParent.visible = false;
		}
	}

	public function clearEvents():Void {
		ButtonUpdater.clearEvents(MC.cardPickMC.fightButton, fightButtonClicked);
		ButtonUpdater.clearEvents(MC.continueButtonParent.continueButton, continueButtonClicked);
	}

	public function nextStepContinue():Void {
		nextStepContinueIntervalTimer.stop();
		//clearInterval(nextStepContinueInterval);
		if (currStep % 2 == 0 && noLife != 0) {
			endFight(noLife);
		} else if (currStep < 6) {
			playStep();
		} else {
			endRound();
		}
	}

	public function resetFightVars():Void {
		fightStatus = 1;
		roundNum = 0;
		fightStage = 1;
		endAnimIntervalTimer.stop();
		//clearInterval(endAnimInterval);
		nextStepContinueIntervalTimer.stop();
		// clearInterval(nextStepContinueInterval);
		animCardIntervalTimer.stop();
		//clearInterval(animCardInterval);
		winAnimIntervalTimer.stop();
		//clearInterval(winAnimInterval);
		startAnimIntervalTimer.stop();
		//clearInterval(startAnimInterval);
		me.resetFighterVars();
		enemy.resetFighterVars();
	}

	public function showHitMatrix(param1:Dynamic, param2:Int):Void {
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		var _loc6_:ColorTransform = null;
		var _loc7_:Null<Dynamic> = null;
		hitMatrix = BambaAssets.hitMatrix;
		MC.boardMC.backMC.addChild(hitMatrix);
		hitMatrix.y = 260;
		_loc6_ = new ColorTransform();
		_loc7_ = game.gameData.dictionary.COLORS.split(",");
		_loc6_.color = _loc7_[param2 - 1];
		hitMatrix.transform.colorTransform = _loc6_;
		_loc3_ = 0;
		while (_loc3_ < 4) {
			_loc4_ = 0;
			while (_loc4_ < 3) {
				_loc5_ = "x" + _loc3_ + "y" + _loc4_;
				hitMatrix[_loc5_].gotoAndStop("hide");
				_loc4_++;
			}
			_loc3_++;
		}
		_loc3_ = 0;
		while (_loc3_ < param1.length) {
			_loc5_ = "x" + param1[_loc3_][0] + "y" + param1[_loc3_][1];
			hitMatrix[_loc5_].gotoAndStop("show");
			_loc3_++;
		}
	}

	public function startFight():Void {
		noLife = 0;
		MC.cardPickMC.visible = false;
		MC.boardMC.visible = true;
		me.playEneterAnim();
		game.sound.playEffect("MAZE_BATTLE");
		startAnimIntervalTimer = new Timer(1500);
		startAnimIntervalTimer.run = enemyEnterAnim;
		//startAnimInterval = setInterval(enemyEnterAnim, 1500);
	}

	public function setFighters():Void {
		var _loc1_:Null<Dynamic> = null;
		cardsPlayerCanUse = game.gameData.playerData.cards;
		if (enemyData.levelCards.length > 0) {
			cardsEnemyCanUse = enemyData.cards.concat(enemyData.levelCards[enemyLevel - 1]);
		} else {
			cardsEnemyCanUse = enemyData.cards;
		}
		_loc1_ = true;
		me = new BambaFighter(this, _loc1_);
		_loc1_ = false;
		enemy = new BambaFighter(this, _loc1_);
	}

	public function animCards():Void {
		var _loc1_:Int = null;
		var _loc2_:BambaCard = null;
		var _loc3_:BambaCard = null;
		var _loc4_:Int = null;
		var _loc5_:Null<Dynamic> = null;
		var _loc6_:Null<Dynamic> = null;
		var _loc7_:Null<Dynamic> = null;
		_loc1_ = Math.floor(currStep / 2);
		if (_loc1_ != 0) {
			_loc4_ = _loc1_;
			while (_loc4_ < 3) {
				_loc5_ = cardFightLocationAndSize[_loc4_ - _loc1_][0];
				_loc6_ = cardFightLocationAndSize[_loc4_ - _loc1_][1];
				_loc7_ = cardFightLocationAndSize[_loc4_ - _loc1_][2];
				roundCards[_loc4_].setCardDir(me.dir);
				TweenLiteHaxe.to(roundCards[_loc4_].mc, 0.6, {
					"x": _loc5_,
					"y": _loc6_,
					"scaleX": _loc7_,
					"scaleY": _loc7_
				});
				_loc5_ = cardFightLocationAndSize[_loc4_ + 3 - _loc1_][0];
				_loc6_ = cardFightLocationAndSize[_loc4_ + 3 - _loc1_][1];
				_loc7_ = cardFightLocationAndSize[_loc4_ + 3 - _loc1_][2];
				roundCards[_loc4_ + 3].setCardDir(enemy.dir);
				TweenLiteHaxe.to(roundCards[_loc4_ + 3].mc, 0.6, {
					"x": _loc5_,
					"y": _loc6_,
					"scaleX": _loc7_,
					"scaleY": _loc7_
				});
				_loc4_++;
			}
			MC.cardsFightMC.removeChild(roundCards[_loc1_ - 1].mc);
			MC.cardsFightMC.removeChild(roundCards[_loc1_ + 3 - 1].mc);
		}
		_loc2_ = roundCards[_loc1_];
		_loc3_ = roundCards[_loc1_ + 3];
		_loc2_.mc.frontMC.gotoAndStop("reg");
		_loc3_.mc.frontMC.gotoAndStop("reg");
		_loc2_.mc.gotoAndPlay("flip-left");
		_loc3_.mc.gotoAndPlay("flip-right");
		game.sound.playEffect("BATTLE_CARD_FLIP");
		animCardIntervalTimer = new Timer(600);
		animCardIntervalTimer.run = playCardinStep;
		//animCardInterval = setInterval(playCardinStep, 600);
	}

	public function setCardPick():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		cardPickedByPlayer = [0, 0, 0];
		costOfPickedCards = 0;
		_loc1_ = game.help.showTutorial(17);
		if (!_loc1_) {
			_loc1_ = game.help.showTutorial(18);
		}
		_loc2_ = 0;
		_loc3_ = 0;
		_loc4_ = 0;
		while (_loc4_ < cardsPlayerCanUse.length) {
			_loc5_ = game.gameData.getCatalogCard(cardsPlayerCanUse[_loc4_]);
			_loc5_.generateMC(me.dir);
			_loc5_.addClickEvent(this);
			MC.cardPickMC.cardsPickBoardMC.addChild(_loc5_.mc);
			_loc5_.mc.scaleX = 1;
			_loc5_.mc.scaleY = 1;
			if (_loc5_.damage > 0) {
				_loc5_.mc.x = cardUnPicksAttackLocation[_loc3_][0];
				_loc5_.mc.y = cardUnPicksAttackLocation[_loc3_][1];
				_loc3_++;
			} else {
				_loc5_.mc.x = cardUnPicksMoveLocation[_loc2_][0];
				_loc5_.mc.y = cardUnPicksMoveLocation[_loc2_][1];
				_loc2_++;
			}
			_loc4_++;
		}
		showCardPick();
		me.updateIconPos();
		enemy.updateIconPos();
	}

	public function nextStep():Void {
		if (fightStatus == 1) {
			++currStep;
			if (currStep % 2 == 0) {
				me.updateScreenData();
				enemy.updateScreenData();
				nextStepContinueIntervalTimer = new Timer(game.gameData.barAnimLength * 1000);
				nextStepContinueIntervalTimer.run = nextStepContinue;
				//nextStepContinueInterval = setInterval(, game.gameData.barAnimLength * 1000);
			} else {
				nextStepContinue();
			}
		}
	}

	public function enemyEnterAnim():Void {
		startAnimIntervalTimer.stop();
		//clearInterval(startAnimInterval);
		enemy.playEneterAnim();
		startAnimIntervalTimer = new Timer(1500);
		startAnimIntervalTimer.run = setFightMusic;
		//startAnimInterval = setInterval(setFightMusic, 1500);
	}

	public function fightButtonClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (cardPickedByPlayer[0] * cardPickedByPlayer[1] * cardPickedByPlayer[2] > 0) {
				roundCardsIds = [];
				roundCardsIds = roundCardsIds.concat(cardPickedByPlayer);
				roundCardsIds = roundCardsIds.concat(enemy.AI.returnSequence());
				startRoundAnim();
			} else {
				MsgBox.show(game.gameData.dictionary.FIGHT_MUST_PICK_3);
			}
		}
	}

	function endRound():Void {
		me.regenerateMagic(game.gameData.playerData.roundRegeneration);
		enemy.regenerateMagic(enemyLevelData.roundRegeneration);
		me.updateScreenData();
		enemy.updateScreenData();
		me.setDefense(0);
		enemy.setDefense(0);
		MC.continueButtonParent.visible = true;
		MC.continueButtonParent.gotoAndPlay("up");
		MC.cardsFightMC.removeChild(roundCards[2].mc);
		MC.cardsFightMC.removeChild(roundCards[5].mc);
	}

	function setFightMusic():Void {
		startAnimIntervalTimer.stop();
		//clearInterval(startAnimInterval);
		if (game.aDungeon != null) {
			trace("game.aDungeon.dungeonData.fightMusic:" + game.aDungeon.dungeonData.fightMusic);
			game.sound.playMusic(game.aDungeon.dungeonData.fightMusic);
		}
		startAnimIntervalTimer = new Timer(1500);
		startAnimIntervalTimer.run = showContinueAtStart;
		//startAnimInterval = setInterval(showContinueAtStart, 1500);
	}

	public function playCardinStep():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:BambaCard = null;
		var _loc4_:BambaFighter = null;
		if (animCardIntervalTimer != null) {
			animCardIntervalTimer.stop();
			//clearInterval(animCardInterval);
		}
		_loc1_ = Math.floor(currStep / 2);
		_loc2_ = currStep % 2;
		if (_loc2_ == 0) {
			if (roundCards[_loc1_].damage < roundCards[_loc1_ + 3].damage) {
				_loc3_ = roundCards[_loc1_];
				_loc4_ = me;
			} else {
				_loc3_ = roundCards[_loc1_ + 3];
				_loc4_ = enemy;
			}
		} else if (roundCards[_loc1_].damage < roundCards[_loc1_ + 3].damage) {
			_loc3_ = roundCards[_loc1_ + 3];
			_loc4_ = enemy;
		} else {
			_loc3_ = roundCards[_loc1_];
			_loc4_ = me;
		}
		_loc4_.useCard(_loc3_);
		_loc3_.mc.frontMC.gotoAndStop("frame");
	}

	public function showCardPick():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		MC.cardPickMC.visible = true;
		MC.boardMC.visible = false;
		_loc1_ = 0;
		while (_loc1_ < cardsPlayerCanUse.length) {
			_loc2_ = game.gameData.getCatalogCard(cardsPlayerCanUse[_loc1_]);
			_loc2_.mc.visible = true;
			_loc2_.setCardDir(me.dir);
			_loc1_++;
		}
		disableExpensiveCards();
	}
}
