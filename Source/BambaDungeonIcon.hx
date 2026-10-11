package;

import dungeon_graphics.EnemyTip;
import dungeon_graphics.DungeonIcon;
import motion.Actuate;
import openfl.display.DisplayObject;
import openfl.display.*;
import openfl.events.MouseEvent;
import general.Heb;

class BambaDungeonIcon extends DisplayObject {
	public var popupMC:EnemyTip;

	public var type:Int;

	public var currTileId:Float;

	var movePath:Array<Dynamic>;

	var forceLevel:Bool;

	public var enemyLevel:Float;

	// Typed, not Dynamic: through Dynamic every `iconGraphics.scaleX = ...` is a reflective
	// property set, which hxcpp rejects with "Invalid field:scaleX".
	public var iconGraphics:DungeonIcon;

	public var isSpecial:Bool;

	public var currLevel:Float;

	public var dungeon:BambaDungeon;

	public function new(param1:Dynamic, param2:Dynamic) {
		super();
		dungeon = param1;
		type = param2;
		isSpecial = false;
		iconGraphics = new DungeonIcon();
		switch (type) {
			case 1:
				iconGraphics.iconMC.gotoAndStop("me");
				iconGraphics.scaleX = 1;
			case 2:
				iconGraphics.iconMC.gotoAndStop("enemy");
				setEnemyLevel();
				popupMC = new EnemyTip();
				iconGraphics.iconMC.addEventListener(MouseEvent.ROLL_OVER, enemyRolledOver);
				iconGraphics.iconMC.addEventListener(MouseEvent.ROLL_OUT, enemyRolledOut);
			case 3:
				iconGraphics.iconMC.gotoAndStop("boss");
				setEnemyLevel();
				popupMC = new EnemyTip();
				iconGraphics.iconMC.addEventListener(MouseEvent.ROLL_OVER, enemyRolledOver);
				iconGraphics.iconMC.addEventListener(MouseEvent.ROLL_OUT, enemyRolledOut);
			case 4:
				iconGraphics.iconMC.gotoAndStop("treasure");
			case 5:
				iconGraphics.iconMC.gotoAndStop("surprize");
		}
		markSpecial(false);
		currLevel = 1;
		forceLevel = false;
	}

	public function changeAndForceLevel(param1:Int):Void {
		putOnLevel(param1);
		forceLevel = true;
		currLevel = param1;
	}

	/**
		Puts the icon on the board layer for a tile height: level 2 (bridges, walkways) is
		`uperMC`, drawn over the walls; level 1 is `lowerMC`, under them. Always on top of that
		layer's other icons.

		The port had the uperMC branches commented out but kept their `else`, which then bound
		to the "is it on lowerMC" check: an icon changing level was removed and never put back.
		Every icon placed on a raised tile vanished as soon as it was set up (enemies, treasures
		and bags), and the player's token vanished on its first step onto one.
	**/
	public function putOnLevel(level:Float):Void {
		var lower = dungeon.dungeonMC.lowerMC;
		var upper = dungeon.dungeonMC.uperMC;
		removeFromBoard();
		var layer = level == 2 && upper != null ? upper : lower;
		if (layer != null) layer.addChild(iconGraphics);
	}

	/** Takes the icon off the board, whichever layer it is on. **/
	public function removeFromBoard():Void {
		if (iconGraphics.parent != null) iconGraphics.parent.removeChild(iconGraphics);
	}

	/** Moves the icon to the bottom or top of its layer's icons. **/
	public function sendTo(top:Bool):Void {
		var layer = iconGraphics.parent;
		if (layer != null) layer.setChildIndex(iconGraphics, top ? layer.numChildren - 1 : 0);
	}

	public function markSpecial(param1:Bool):Void {
		if (param1) {
			isSpecial = true;
			iconGraphics.specialMC.gotoAndPlay("special");
		} else {
			isSpecial = false;
			iconGraphics.specialMC.gotoAndStop("reg");
		}
	}

	function enemyRolledOver(param1:MouseEvent):Void {
		if (!dungeon.game.msgShown) {
			Heb.setText(popupMC.NAME, dungeon.game.gameData.getCatalogEnemy(dungeon.enemyId, type - 1).eName);
			Heb.setText(popupMC.LEVEL, dungeon.game.gameData.dictionary.CHARACTER_LEVEL + " " + enemyLevel);
			dungeon.dungeonMC.addChild(popupMC);
			if (iconGraphics.x < 400) {
				if (iconGraphics.y < 300) {
					popupMC.x = iconGraphics.x + iconGraphics.width / 2;
					popupMC.y = iconGraphics.y;
					popupMC.backMC.gotoAndStop(1);
				} else {
					popupMC.x = iconGraphics.x + iconGraphics.width / 2;
					popupMC.y = iconGraphics.y - 40;
					popupMC.backMC.gotoAndStop(4);
				}
			} else if (iconGraphics.y < 300) {
				popupMC.x = iconGraphics.x - 140;
				popupMC.y = iconGraphics.y;
				popupMC.backMC.gotoAndStop(2);
			} else {
				popupMC.x = iconGraphics.x - 140;
				popupMC.y = iconGraphics.y - 40;
				popupMC.backMC.gotoAndStop(3);
			}
		}
	}

	public function setLevel(param1:BambaDungeonTile = null):Void {
		var _loc2_:BambaDungeonTile = null;
		var _loc3_:Float = Math.NaN;
		_loc2_ = dungeon.dungeonData.getTile(currTileId);
		if (param1 == null) {
			_loc3_ = _loc2_.level;
		} else {
			_loc3_ = Math.max(_loc2_.level, param1.level);
		}
		if (currLevel != _loc3_) {
			putOnLevel(_loc3_);
			currLevel = _loc3_;
		}
	}

	function moveToTileInPath():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:BambaDungeonTile = null;
		var _loc4_:Null<Dynamic> = null;
		if (movePath.length > 0) {
			dungeon.game.sound.playEffect("MAZE_MOVEMENT");
			_loc1_ = 0.5;
			_loc2_ = movePath.shift();
			_loc3_ = dungeon.dungeonData.getTile(_loc2_);
			_loc4_ = dungeon.game.gameData.defaultDungeonAnimLength;
			if (iconGraphics.x > _loc3_.x) {
				iconGraphics.scaleX = 1;
			} else {
				iconGraphics.scaleX = -1;
			}
			// onComplete is a method of the tween, not a property to animate (AS3 TweenLite
			// took it in the vars object; Actuate would try to tween a field by that name).
			Actuate.tween(iconGraphics, _loc4_, {
				x: _loc3_.x,
				y: _loc3_.y
			}).onComplete(moveFinish);
			setLevel(_loc3_);
			currTileId = _loc2_;
		} else {
			pathFinish();
		}
	}

	public function jumpToTile(param1:Dynamic, param2:Bool = false, param3:Float = 0):Void {
		var _loc4_:BambaDungeonTile = null;
		_loc4_ = dungeon.dungeonData.getTile(param1);
		if (param3 == 0) {
			param3 = dungeon.game.gameData.defaultDungeonAnimLength;
		}
		if (iconGraphics.x > _loc4_.x) {
			iconGraphics.scaleX = 1;
		} else {
			iconGraphics.scaleX = -1;
		}
		Actuate.tween(iconGraphics, param3, {
			x: _loc4_.x,
			y: _loc4_.y
		}).onComplete(jumpToTileFinish, [param2]);
		if (!forceLevel) {
			setLevel(_loc4_);
		} else {
			forceLevel = false;
		}
		currTileId = param1;
	}

	function pathFinish():Void {
		setTile(currTileId);
		setLevel();
		dungeon.pathFinish();
	}

	public function moveInPath(param1:Dynamic):Void {
		// Numbers, not the strings split() gives: each step is stored in currTileId (a Float).
		movePath = [for (step in (param1 : String).split(",")) Std.parseFloat(step)];
		movePath.shift();
		moveToTileInPath();
	}

	function jumpToTileFinish(param1:Bool):Void {
		setTile(currTileId);
		setLevel();
		if (type == 1) {
			dungeon.jumpFinish(param1);
		}
		if (type == 2) {
			dungeon.enemyMoveFinish();
		}
	}

	function setEnemyLevel():Void {
		var _loc1_:Null<Dynamic> = null;
		_loc1_ = dungeon.game.gameData.dungeonDifficulties[dungeon.dungeonDifficulty][type - 2];
		enemyLevel = dungeon.game.gameData.playerData.level + Std.parseFloat(_loc1_[Math.floor(Math.random() * _loc1_.length)]);
		if (enemyLevel < dungeon.game.gameData.minEnemyLevel) {
			enemyLevel = dungeon.game.gameData.minEnemyLevel;
		}
		if (enemyLevel > dungeon.game.gameData.maxEnemyLevel) {
			enemyLevel = dungeon.game.gameData.maxEnemyLevel;
		}
	}

	function moveFinish():Void {
		moveToTileInPath();
	}

	function enemyRolledOut(param1:MouseEvent):Void {
		if (dungeon.dungeonMC.contains(popupMC)) {
			dungeon.dungeonMC.removeChild(popupMC);
		}
	}

	public function setTile(param1:Dynamic):Void {
		var _loc2_:BambaDungeonTile = null;
		currTileId = param1;
		_loc2_ = dungeon.dungeonData.getTile(param1);
		iconGraphics.x = _loc2_.x;
		iconGraphics.y = _loc2_.y;
		setLevel();
	}

	function setDungeon(param1:Dynamic):Void {
		dungeon = param1;
	}
}
