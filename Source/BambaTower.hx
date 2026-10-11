package;

import tower_screens.TowerScreen;
import openfl.display.*;
import openfl.events.Event;
import openfl.events.MouseEvent;
import general.ButtonUpdater;

class BambaTower extends Sprite {
	public var mc:TowerScreen;

	var game:BambaMain;

	/**
		Parallax layers, nearest first: each scrolls `1 / divisor` of the mouse offset per frame.
		Typed rather than Array<Dynamic> - a Dynamic `.x` is reflective and throws "Invalid field:x"
		on hxcpp, which crashed the game as soon as the mouse reached a scroll edge.
	**/
	var layers:Array<{clips:Array<DisplayObject>, divisor:Float}>;

	/** How far the nearest layer has scrolled: 0 at the left end, -750 at the right. **/
	var scrollPos:Float;

	var movingRight:Bool;

	var movingLeft:Bool;

	public function new(mainGame:BambaMain) {
		super();
		game = mainGame;
		mc = new TowerScreen();
		mc.rightArrowMC.gotoAndStop(1);
		mc.leftArrowMC.gotoAndStop(1);
		ButtonUpdater.setButton(mc.exitMC, exitClicked);
		ButtonUpdater.setButton(mc.questMC, questClicked);
		ButtonUpdater.setButton(mc.magicMC, magicClicked);
		ButtonUpdater.setButton(mc.upgradeMC, upgradeClicked);
		ButtonUpdater.setButton(mc.storeMC, storeClicked);
		mc.characterMC.addEventListener(MouseEvent.CLICK, characterClicked);
		mc.characterMC.buttonMode = true;
		mc.characterMC.tabEnabled = false;
		layers = [
			{clips: [mc.towerBackMC, mc.exitMC], divisor: 5},
			{clips: [mc.upgradeMC, mc.storeMC], divisor: 4.8},
			{clips: [mc.columnsMC], divisor: 4.2},
			{clips: [mc.questMC, mc.magicMC], divisor: 3.5},
		];
		movingLeft = false;
		movingRight = false;
		scrollPos = 0;
		mc.moveRightMC.addEventListener(MouseEvent.ROLL_OVER, setMoveRightOn);
		mc.moveRightMC.addEventListener(MouseEvent.ROLL_OUT, setMoveRightOff);
		mc.moveRightMC.addEventListener(Event.ENTER_FRAME, moveRight);
		mc.moveLeftMC.addEventListener(MouseEvent.ROLL_OVER, setMoveLeftOn);
		mc.moveLeftMC.addEventListener(MouseEvent.ROLL_OUT, setMoveLeftOff);
		mc.moveLeftMC.addEventListener(Event.ENTER_FRAME, moveLeft);
		updateQuestIcon();
	}

	public function updateQuestIcon():Void {
		mc.exitMC.specialMC.gotoAndStop("reg");
		mc.questMC.specialMC.gotoAndStop("reg");
		if (game.questManager != null) {
			if (game.questManager.currQuestId != 0) {
				mc.exitMC.specialMC.gotoAndPlay("special");
			} else {
				mc.questMC.specialMC.gotoAndStop("special");
			}
		}
	}

	// Scrolling ran once per frame of the original 30 fps movie. It is scaled by elapsed time
	// here, so the speed stays the same at any frame rate (60, 144, ...).
	static inline var AUTHORED_FPS = 30;

	var lastRightStamp = 0.0;
	var lastLeftStamp = 0.0;

	/** Frames of the 30 fps original that have passed since `last`; capped so a stall doesn't jump. **/
	static function authoredFrames(last:Float, now:Float):Float {
		if (last <= 0) return 1;
		return Math.min((now - last) * AUTHORED_FPS, 3);
	}

	function moveRight(_:Event):Void {
		var now = haxe.Timer.stamp();
		if (movingRight && scrollPos > -750) {
			scroll(-mc.moveRightMC.mouseX * authoredFrames(lastRightStamp, now));
		}
		lastRightStamp = now;
	}

	function moveLeft(_:Event):Void {
		var now = haxe.Timer.stamp();
		if (movingLeft && scrollPos < 0) {
			scroll((mc.moveLeftMC.width - mc.moveLeftMC.mouseX) * authoredFrames(lastLeftStamp, now));
		}
		lastLeftStamp = now;
	}

	/** Moves every layer by `offset` scaled to its depth; negative scrolls right. **/
	function scroll(offset:Float):Void {
		for (layer in layers) {
			for (clip in layer.clips) {
				clip.x += offset / layer.divisor;
			}
		}
		scrollPos += offset / layers[0].divisor;
	}

	function upgradeClicked(_:MouseEvent):Void {
		if (!game.msgShown) {
			game.showUpgradeCrads();
		}
	}

	function magicClicked(_:MouseEvent):Void {
		if (!game.msgShown) {
			game.showMagicBook();
		}
	}

	function setMoveLeftOff(_:MouseEvent):Void {
		movingLeft = false;
		mc.leftArrowMC.gotoAndStop(1);
	}

	function setMoveRightOn(_:MouseEvent):Void {
		if (!game.msgShown) {
			movingRight = true;
			mc.rightArrowMC.gotoAndStop(2);
		}
	}

	function setMoveLeftOn(_:MouseEvent):Void {
		if (!game.msgShown) {
			movingLeft = true;
			mc.leftArrowMC.gotoAndStop(2);
		}
	}

	function setMoveRightOff(_:MouseEvent):Void {
		movingRight = false;
		mc.rightArrowMC.gotoAndStop(1);
	}

	function exitClicked(_:MouseEvent):Void {
		if (!game.msgShown) {
			game.showMap();
		}
	}

	function questClicked(_:MouseEvent):Void {
		if (!game.msgShown) {
			game.showQuestManager();
		}
	}

	function characterClicked(_:MouseEvent):Void {
		if (!game.msgShown) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			game.showCharacter();
		}
	}

	function storeClicked(_:MouseEvent):Void {
		if (!game.msgShown) {
			game.showStore();
		}
	}
}
