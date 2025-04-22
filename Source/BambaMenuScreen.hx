package;

import menu.MenuScreen;
import haxe.Timer;
import openfl.display.*;
import openfl.events.MouseEvent;
import openfl.utils.*;
import general.ButtonUpdater;
import general.Heb;
import general.MsgBox;

class BambaMenuScreen extends Sprite {
   var clickContIntervalTimer: Timer = null;
	var babyGraphics:MovieClip;

	public var mc:MenuScreen;

	var game:BambaMain;

	public function new(mainGame:BambaMain) {
		super();
		game = mainGame;
		mc = new MenuScreen();
		babyGraphics = BambaAssets.babyMain;
		babyGraphics.stop();
		mc.babyMC.addChild(babyGraphics);
		babyGraphics.scaleX = 1.8;
		babyGraphics.scaleY = 1.8;
		babyGraphics.x = 100;
		babyGraphics.y = 290;
		ButtonUpdater.setButton(mc.menuMC.startMC, startClicked);
		ButtonUpdater.setButton(mc.menuMC.videoMC, vidoeClicked);
		ButtonUpdater.setButton(mc.menuMC.newCharacterMC, newCharacterClicked);
		ButtonUpdater.setButton(mc.menuMC.helpMC, helpClicked);
		ButtonUpdater.setButton(mc.menuMC.exitMC, exitClicked);
		update();
	}

	function vidoeClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.msgShown = true;
			slideOut();
         clickContIntervalTimer = new Timer(500);
         clickContIntervalTimer.run = vidoeClickedCont;
			// clickContInterval = setInterval(vidoeClickedCont, 500);
			game.innerCount(16);
		}
	}

	public function update():Void {
		var _loc1_:Null<Dynamic> = null;
		if (game.gameData.playerData.pName != "") {
			babyGraphics.visible = true;
			game.gameData.playerData.updateBabysLook(babyGraphics);
			_loc1_ = game.gameData.dictionary.CH_B_OREDER_PRE + game.gameData.dictionary.ORDERS.split(",")[game.gameData.playerData.orderCode - 1];
			Heb.setText(mc.plateMC.orderDT, _loc1_);
			Heb.setText(mc.plateMC.nameDT, game.gameData.playerData.pName);
			Heb.setText(mc.plateMC.levelDT, game.gameData.dictionary.CHARACTER_LEVEL + " " + game.gameData.playerData.level);
		} else {
			babyGraphics.visible = false;
			mc.plateMC.orderDT.text = "";
			mc.plateMC.nameDT.text = "";
			mc.plateMC.levelDT.text = "";
		}
	}

	function confirmNewCharacter():Void {
		game.msgShown = true;
		slideOut();
      clickContIntervalTimer = new Timer(500);
      clickContIntervalTimer.run = confirmNewCharacterCont;
		// clickContInterval = setInterval(confirmNewCharacterCont, 500);
	}

	function vidoeClickedCont():Void {
      clickContIntervalTimer.stop();
		// clearInterval(clickContInterval);
		game.msgShown = false;
		game.movie.loadAndShow();
	}

	function confirmNewCharacterCont():Void {
      clickContIntervalTimer.stop();
		// clearInterval(clickContInterval);
		game.msgShown = false;
		game.innerCount(17);
		game.showCharacterBuild();
	}

	function slideOut():Void {
		game.sound.playEffect("GENERAL_MENU_SLIDE_OUT");
		mc.gotoAndPlay("slideOut");
	}

	function startClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.msgShown = true;
			slideOut();
         clickContIntervalTimer = new Timer(500);
         clickContIntervalTimer.run = startClickedCont;
			// lickContInterval = setInterval(startClickedCont, 500);
			game.innerCount(15);
		}
	}

	function helpClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.openHelp(param1);
		}
	}

	function exitClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.msgShown = true;
			slideOut();
         clickContIntervalTimer = new Timer(500);
         clickContIntervalTimer.run = exitClickedCont;
			// clickContInterval = setInterval(exitClickedCont, 500);
			game.innerCount(18);
		}
	}

	public function slideIn():Void {
		game.sound.playEffect("GENERAL_MENU_SLIDE_IN");
		mc.gotoAndPlay("slideIn");
	}

	function startClickedCont():Void {
      clickContIntervalTimer.stop();
		// clearInterval(clickContInterval);
		game.msgShown = false;
		if (game.gameData.playerData.pName != "") {
			game.showTower();
		} else {
			game.showCharacterBuild();
			MsgBox.show(game.gameData.dictionary.MENU_NO_CHARACTER);
		}
	}

	function exitClickedCont():Void {
      clickContIntervalTimer.stop();
		// clearInterval(clickContInterval);
		game.msgShown = false;
		game.exitToOpeningScreen();
	}

	function newCharacterClicked(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.sound.playEffect("GENERAL_WARNING");
			MsgBox.showYesNoBox(game.gameData.dictionary.MENU_NEW_CHARACTER, confirmNewCharacter);
		}
	}
}
