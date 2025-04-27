package;

import dungeon_graphics.DungeonIcon;
import map_graphics.MapIcon;
import map_graphics.KingdomMap;
import openfl.display.*;
import openfl.events.MouseEvent;
import openfl.utils.*;
import haxe.Timer;
class BambaMap extends DisplayObject {
	var dungeons:Array<Array<Int>>;

	var areas:Array<Dynamic>;

	var game:BambaMain;

   var mapAnimIntervalTimer: Timer;
	//var mapAnimInterval:Float;

	public var mc:Dynamic;

	var firstTime:Bool;

	var mapIcons:Array<MapIcon>;

	var currDungeonId:Float;

	var areasShown:Array<Dynamic>;

	var canWalk:Bool;

   var addDungeonIntervalTimer :Timer;
	//var addDungeonInterval:Float;

	public function new(mainGame:BambaMain) {
		super();
		game = mainGame;
		mc = new KingdomMap();
		//mc.orgWidth = mc.width;
		//mc.orgHeight = mc.height;
		mc.towerMC.addEventListener(MouseEvent.CLICK, towerClicked);
		mc.towerMC.buttonMode = true;
		mc.towerMC.tabEnabled = false;
		areas = game.gameData.mapData.areas;
		dungeons = game.gameData.mapData.dungeons;
		mc.showCharacterMC.addEventListener(MouseEvent.CLICK, openCharacterWin);
		mc.showCharacterMC.buttonMode = true;
		mc.showCharacterMC.tabEnabled = false;
		resetMap();
	}

	public function update():Void {
		var _loc1_:Null<Dynamic> = null;
		if (game.questManager.currQuestDungeonId != 0) {
			_loc1_ = 0;
			while (_loc1_ < mapIcons.length) {
				if (mapIcons[_loc1_].dongeonId == game.questManager.currQuestDungeonId) {
					mapIcons[_loc1_].specialMC.gotoAndPlay(2);
				} else {
					mapIcons[_loc1_].specialMC.gotoAndStop(1);
				}
				_loc1_++;
			}
			mc.towerMC.specialMC.gotoAndStop(1);
		} else {
			mc.towerMC.specialMC.gotoAndPlay(2);
			_loc1_ = 0;
			while (_loc1_ < mapIcons.length) {
				mapIcons[_loc1_].specialMC.gotoAndStop(1);
				_loc1_++;
			}
		}
	}

	function dongeonClicked(param1:MouseEvent):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		var _loc6_:String = null;
		var _loc7_:Null<Dynamic> = null;
		var _loc8_:Null<Dynamic> = null;
		if (!game.msgShown) {
			if (canWalk) {
				game.msgShown = true;
				canWalk = false;
				if (currDungeonId == param1.currentTarget.dongeonId) {
					afterDongeonClickedAnim();
				} else if (currDungeonId == 0) {
					_loc4_ = param1.currentTarget.dongeonId;
					_loc3_ = currDungeonId + "to" + _loc4_;
					mc.mapAnimMC.gotoAndPlay(_loc3_);
					currDungeonId = _loc4_;
					_loc5_ = getAnimTime(_loc3_);
               mapAnimIntervalTimer = new Timer(_loc5_);
               mapAnimIntervalTimer.run = afterDongeonClickedAnim;
					//mapAnimInterval = setInterval(afterDongeonClickedAnim, _loc5_);
					game.sound.playEffect("MAP_MOVEMENT");
				} else {
					_loc7_ = false;
					_loc4_ = param1.currentTarget.dongeonId;
					_loc3_ = currDungeonId + "to" + _loc4_;
					_loc5_ = getAnimTime(_loc3_);
					_loc8_ = 0;
					while (_loc8_ < game.gameData.mapTrails.length) {
						if (_loc3_ == game.gameData.mapTrails[_loc8_]) {
							_loc7_ = true;
							break;
						}
						_loc8_++;
					}
					if (_loc7_) {
						mc.mapAnimMC.gotoAndPlay(_loc3_);
						currDungeonId = _loc4_;
                  mapAnimIntervalTimer = new Timer(_loc5_);
                  mapAnimIntervalTimer.run = afterTowerClickedAnim;
						// mapAnimInterval = setInterval(afterDongeonClickedAnim, _loc5_);
						game.sound.playEffect("MAP_MOVEMENT");
					} else {
						_loc3_ = currDungeonId + "to0";
						_loc5_ = getAnimTime(_loc3_);
						mc.mapAnimMC.gotoAndPlay(_loc3_);
						currDungeonId = _loc4_;
                  mapAnimIntervalTimer = new Timer(_loc5_);
                  mapAnimIntervalTimer.run = secondMove;
						// mapAnimInterval = setInterval(secondMove, _loc5_);
						game.sound.playEffect("MAP_MOVEMENT");
					}
				}
			}
		}
	}

	function dongeonRollOver(param1:MouseEvent):Void {
		//var _loc2_:Null<Dynamic> = null;
		if (!game.msgShown) {
			var _dungeonData = game.gameData.getCatalogDungeonData(param1.currentTarget.dongeonId);
			param1.currentTarget.iconMC.gotoAndStop(2);
			param1.currentTarget.iconMC.DT.text = _dungeonData.dName;
		}
	}

	function afterTowerClickedAnim():Void {
		currDungeonId = 0;
      mapAnimIntervalTimer.stop();
		// clearInterval(mapAnimInterval);
		canWalk = true;
		game.msgShown = false;
		game.sound.stopEffects();
		game.showTower();
	}

	public function setMap():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		canWalk = true;
		mapIcons = [];
		while (mc.iconsMC.numChildren > 0) {
			mc.iconsMC.removeChildAt(0);
		}
		_loc1_ = 0;
		while (_loc1_ < areas.length) {
			_loc4_ = false;
			_loc2_ = 0;
			while (_loc2_ < game.gameData.playerData.pastDungeonsIds.length) {
				_loc3_ = game.gameData.getCatalogDungeonData(game.gameData.playerData.pastDungeonsIds[_loc2_]);
				if (areas[_loc1_][0] == _loc3_.areaCode) {
					_loc4_ = true;
					if (areasShown.indexOf(areas[_loc1_][0]) == -1 && !firstTime) {
						addDungeonIcon(_loc3_.id);
						mapIcons[mapIcons.length - 1].visible = false;
                  addDungeonIntervalTimer = new Timer(1500);
                  addDungeonIntervalTimer.run = showAllDungeons;
						// addDungeonInterval = setInterval(showAllDungeons, 1500);
					} else {
						if (game.help.currTutorialCode == 4) {
							game.help.finishTutorial();
						}
						addDungeonIcon(_loc3_.id);
					}
				}
				_loc2_++;
			}
			if (areas[_loc1_][0] == 1) {
				_loc4_ = true;
			}
			if (_loc4_) {
				if (firstTime) {
					mc[areas[_loc1_][2]].gotoAndStop("show");
					areasShown.push(areas[_loc1_][0]);
				} else if (areasShown.indexOf(areas[_loc1_][0]) != -1) {
					mc[areas[_loc1_][2]].gotoAndStop("show");
				} else {
					mc[areas[_loc1_][2]].gotoAndPlay("show-anim");
					areasShown.push(areas[_loc1_][0]);
					game.sound.playEffect("MAP_REVEAL");
				}
			} else {
				mc[areas[_loc1_][2]].gotoAndStop("hide");
			}
			_loc1_++;
		}
		if (firstTime) {
			currDungeonId = 0;
			firstTime = false;
		}
		update();
	}

	public function resetMap():Void {
		areasShown = [];
		firstTime = true;
		setMap();
	}

	function getAnimTime(animTimeId:String):Float {
		final defaultAnimTime = game.gameData.mapTimeDef * 1000;
		final animTime = game.gameData.mapTimes.get(animTimeId);

		return animTime != null ? animTime * 1000: defaultAnimTime;
		/* var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		_loc2_ = game.gameData.mapTimeDef * 1000;
		_loc3_ = 0;
		while (_loc3_ < game.gameData.mapTimes.length) {
			if (param1 == game.gameData.mapTimes[_loc3_][0]) {
				_loc2_ = game.gameData.mapTimes[_loc3_][1] * 1000;
				break;
			}
			_loc3_++;
		}
		return _loc2_; */
	}

	public function setBabyAtTower():Void {
		mc.mapAnimMC.gotoAndStop(1);
		currDungeonId = 0;
	}

	function dongeonRollOut(param1:MouseEvent):Void {
		param1.currentTarget.iconMC.gotoAndStop(1);
		param1.currentTarget.iconMC.DT.text = "";
	}

	function secondMove():Void {
		var _loc1_:Null<Dynamic> = null;
		var _loc2_:Null<Dynamic> = null;
      mapAnimIntervalTimer.stop();
		// clearInterval(mapAnimInterval);
		_loc1_ = "0to" + currDungeonId;
		_loc2_ = getAnimTime(_loc1_);
		mc.mapAnimMC.gotoAndPlay(_loc1_);
      mapAnimIntervalTimer = new Timer(_loc2_);
      mapAnimIntervalTimer.run = afterTowerClickedAnim;
		// mapAnimInterval = setInterval(afterDongeonClickedAnim, _loc2_);
		game.sound.playEffect("MAP_MOVEMENT");
	}

	function openCharacterWin(param1:MouseEvent):Void {
		if (!game.msgShown) {
			game.showCharacter();
		}
	}

	function towerClicked(param1:MouseEvent):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		if (!game.msgShown) {
			if (canWalk) {
				canWalk = false;
				game.msgShown = true;
				if (currDungeonId == 0) {
					afterTowerClickedAnim();
				} else {
					_loc2_ = currDungeonId + "to0";
					_loc3_ = getAnimTime(_loc2_);
					mc.mapAnimMC.gotoAndPlay(_loc2_);
               mapAnimIntervalTimer = new Timer(_loc3_);
               mapAnimIntervalTimer.run = afterDongeonClickedAnim;
					//mapAnimInterval = setInterval(afterTowerClickedAnim, _loc3_);
					game.sound.playEffect("MAP_MOVEMENT");
				}
			}
		}
	}

	function addDungeonIcon(dungeonId:Float):Void {
		//var _loc2_:Null<Dynamic> = null;
		//var _loc3_:Null<Dynamic> = null;
		//var _loc4_:Null<Dynamic> = null;
		//var _loc5_:Null<Dynamic> = null;
		var _loc2_ = game.gameData.getCatalogDungeonData(dungeonId);
		var _mapIcon = new MapIcon();
		mc.iconsMC.addChild(_mapIcon);
		//TODO: is this neccecery?
		//_mapIcon.dongeonId = dungeonId;
		var _index = 0;
		//_loc5_ = 0;
		for (i in 0...dungeons.length) {
			if (dungeons[i][0] == dungeonId) {
				_index = i;
			}
		}
		/* while (_loc5_ < dungeons.length) {
			if (dungeons[_loc5_][0] == dungeonId) {
				_index = _loc5_;
			}
			_loc5_++;
		} */
		_mapIcon.x = dungeons[_index][1];
		_mapIcon.y = dungeons[_index][2];
		_mapIcon.iconMC.mazeIconMC.gotoAndStop(_loc2_.areaCode);
		_mapIcon.buttonMode = true;
		_mapIcon.tabEnabled = false;
		_mapIcon.addEventListener(MouseEvent.CLICK, dongeonClicked);
		_mapIcon.addEventListener(MouseEvent.ROLL_OVER, dongeonRollOver);
		_mapIcon.addEventListener(MouseEvent.ROLL_OUT, dongeonRollOut);
		mapIcons.push(_mapIcon);
	}

	function afterDongeonClickedAnim():Void {
      mapAnimIntervalTimer.stop();
		// clearInterval(mapAnimInterval);
		canWalk = true;
		game.msgShown = false;
		game.sound.stopEffects();
		game.startDungeon(currDungeonId);
	}

	function showAllDungeons():Void {
		//var _loc1_:Null<Dynamic> = null;
		game.help.showTutorial(5);
      addDungeonIntervalTimer.stop();
		//clearInterval(addDungeonInterval);
		/* _loc1_ = 0; */
		for (i in 0...mapIcons.length) {
			mapIcons[i].visible = true;
		}
		/* while (_loc1_ < mapIcons.length) {
			mapIcons[_loc1_].visible = true;
			_loc1_++;
		} */
	}
}
