package;

import general_assets.VolumeBar_8;
import haxe.macro.Expr.Field;
import haxe.Timer;
import openfl.display.*;
import openfl.events.*;
import openfl.geom.Rectangle;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.net.URLRequest;
import openfl.utils.*;
import general.MsgBox;

typedef MusicMC = {
	sliderMC: MovieClip,
	maskMC: MovieClip,
	backMC: MovieClip,
}

/* typedef MusicVolumeBarMC = {
	sliderMC: MovieClip,
	maskMC: MovieClip,
}
 */
class BambaSoundManager extends DisplayObject {
	// AS3 stored each loaded sound as a dynamic property (this[NAME]) backed by one declared
	// field per sound. Haxe classes are not dynamic, so they live in a map instead. Keys are
	// the sounds.xml tag names uppercased - the form playEffect()/playMusic() are called with,
	// and the form <music> uses in dungeonsData.xml.
	var soundLibrary:Map<String, Sound> = new Map();

	var soundsIndex:Int;

	var dungeonMusicIndex:Int;

	var currMusicName:String;

	var currDungeonMusicNames:Array<Dynamic>;

	var dungeonMusicNames:Array<Dynamic>;

	public var effectsTransform:SoundTransform;

	var continueLoadingIntervalTimer:Timer = null;
	// var continueLoadingInterval:Float;

	var musicVolumeBarMC:VolumeBar_8;

	public var musicTransform:SoundTransform;

	var draggingMusicVol:Bool;

	var loadingCounterForDungeon:Float;

	var START_VOL:Dynamic = 0.7;

	public var effectsArray:Array<SoundChannel>;

	public var loopEffectsArray:Array<SoundChannel>;

	public var musicArray:Array<SoundChannel>;

	var draggingEffectsVol:Bool;

	var lastLoadingCounter:Float;

	var loadingCounter:Float;

	var soundNames:Array<Dynamic>;

	var soundsFiles:Array<Dynamic>;

	var effectsVolumeBarMC:VolumeBar_8;


	var currDungeonMusicFiles:Array<Dynamic>;

	var lastLoadingCounterForDungeon:Float;

	var continueLoadingIntervalForDungeonTimer: Timer = null;
	//var continueLoadingIntervalForDungeon:Float;

	var dungeonMusicFiles:Array<Dynamic>;

	var game:BambaMain;

	public function new(mainGame:BambaMain) {
		START_VOL = 0.7;
		super();
		game = mainGame;
		effectsArray = [];
		musicArray = [];
		loopEffectsArray = [];
		effectsTransform = new SoundTransform();
		musicTransform = new SoundTransform();
		if (game.userSharedObject.data.musicVolume != null) {
			musicTransform.volume = game.userSharedObject.data.musicVolume;
		} else {
			musicTransform.volume = START_VOL;
		}
		if (game.userSharedObject.data.effectsVolume != null) {
			effectsTransform.volume = game.userSharedObject.data.effectsVolume;
		} else {
			effectsTransform.volume = START_VOL;
		}
		soundsIndex = 0;
		currMusicName = "";
	}

	function loadDungeonMusicCompleteNoEvent():Void {
		++dungeonMusicIndex;
		loadDungeonMusic();
	}

	public function playEffect(effect:String):Void {
		var _soundChannel:SoundChannel = null;
		if (effect != "") {
			var sound = soundLibrary.get(effect);
			if (sound != null) {
				_soundChannel = sound.play(25, 0, effectsTransform);
				// play() returns null when every audio channel is busy.
				if (_soundChannel != null) {
					_soundChannel.addEventListener(Event.SOUND_COMPLETE, effectCompleted, false, 0, true);
					effectsArray.push(_soundChannel);
				}
			}
		}
	}

	public function setLoadDungeonMusic(param1:Dynamic):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		currDungeonMusicNames = [];
		currDungeonMusicFiles = [];
		_loc2_ = 0;
		while (_loc2_ < dungeonMusicNames.length) {
			_loc3_ = 0;
			while (_loc3_ < param1.length) {
				if (dungeonMusicNames[_loc2_] == param1[_loc3_]) {
					currDungeonMusicNames.push(dungeonMusicNames[_loc2_]);
					currDungeonMusicFiles.push(dungeonMusicFiles[_loc2_]);
				}
				_loc3_++;
			}
			_loc2_++;
		}
		dungeonMusicIndex = 0;
		setContinueLoadingForDungeon();
		loadDungeonMusic();
	}

	function continueLoadingForDungeon():Void {
		loadDungeonMusic();
	}

	public function setEffectsVolumeBar(sfxVolumeBar:VolumeBar_8):Void {
		effectsVolumeBarMC = sfxVolumeBar;
		draggingEffectsVol = false;
		effectsVolumeBarMC.sliderMC.x = effectsTransform.volume * (effectsVolumeBarMC.backMC.width - effectsVolumeBarMC.sliderMC.width);
		effectsVolumeBarMC.maskMC.width = effectsVolumeBarMC.sliderMC.x + effectsVolumeBarMC.sliderMC.width;
		effectsVolumeBarMC.sliderMC.addEventListener(MouseEvent.MOUSE_DOWN, dragEffectsVol);
		effectsVolumeBarMC.sliderMC.buttonMode = true;
		effectsVolumeBarMC.sliderMC.tabEnabled = false;
		game.stage.addEventListener(MouseEvent.MOUSE_UP, dropEffectsVol);
	}

	public function stopLoopEffects():Void {
		var _loc1_:SoundChannel = null;
		trace("stopLoopEffects");
		while (loopEffectsArray.length > 0) {
			_loc1_ = loopEffectsArray.pop();
			_loc1_.stop();
			_loc1_ = null;
		}
	}

	// The sounds are bundled assets listed in the generated manifest, not loose files on disk,
	// so the AS3 Sound.load(new URLRequest(path)) this was ported from cannot resolve them on
	// native targets - every load failed with an IO error. Assets.loadMusic() is the OpenFL
	// equivalent. `next` always runs, so one bad file skips instead of stalling the queue.
	function loadSoundAsset(name:String, path:String, onProgress:Float->Void, next:Void->Void):Void {
		if (!Assets.exists(path)) {
			trace("sound missing from asset manifest: " + name + " -> " + path);
			next();
			return;
		}
		Assets.loadMusic(path).onProgress(function(loaded:Int, total:Int):Void {
			if (onProgress != null && total > 0) onProgress(loaded / total * 100);
		}).onComplete(function(sound:Sound):Void {
			soundLibrary.set(name, sound);
			next();
		}).onError(function(err:Dynamic):Void {
			trace("sound failed to load: " + name + " -> " + path + " (" + err + ")");
			next();
		});
	}

	public function stopAll():Void {
		var _loc1_:SoundChannel = null;
		while (musicArray.length > 0) {
			_loc1_ = musicArray.pop();
			_loc1_.stop();
			_loc1_ = null;
		}
		while (loopEffectsArray.length > 0) {
			_loc1_ = loopEffectsArray.pop();
			_loc1_.stop();
			_loc1_ = null;
		}
		while (effectsArray.length > 0) {
			_loc1_ = effectsArray.pop();
			_loc1_.stop();
			_loc1_ = null;
		}
	}

	public function stopEffects():Void {
		var _loc1_:SoundChannel = null;
		while (effectsArray.length > 0) {
			_loc1_ = effectsArray.pop();
			_loc1_.stop();
			_loc1_ = null;
		}
	}

	function dropMusicVol(param1:Event):Void {
		if (draggingMusicVol) {
			musicVolumeBarMC.sliderMC.stopDrag();
			musicVolumeBarMC.sliderMC.removeEventListener(Event.ENTER_FRAME, adjustMusicVol);
			draggingMusicVol = false;
			game.userSharedObject.data.musicVolume = musicTransform.volume;
			game.userSharedObject.flush();
		}
	}

	function continueLoading():Void {
		loadGameSound();
	}

	// <map_music>map_music.mp3</map_music> -> "map_music.mp3"
	static function elementText(node:Xml):String {
		var buf = new StringBuf();
		for (child in node) {
			if (child.nodeType == Xml.PCData || child.nodeType == Xml.CData) {
				buf.add(child.nodeValue);
			}
		}
		return StringTools.trim(buf.toString());
	}

	public function loadSoundsStart(param1:Xml):Void {
		soundNames = [];
		soundsFiles = [];
		dungeonMusicNames = [];
		dungeonMusicFiles = [];
		// Xml.parse() returns a Document node, so descend to the <sounds> root before looking
		// for sections. The section tags are lower case in sounds.xml.
		var root:Xml = param1.nodeType == Xml.Document ? param1.firstElement() : param1;
		if (root == null) {
			trace("loadSoundsStart: sounds.xml has no root element, no sounds will load");
			finishContinueLoading();
			return;
		}
		// Each entry is <tag>file.mp3</tag>: the tag is the sound name, the text is the file.
		// There is no "name" attribute - the AS3 original read these through e4x.
		for (section in root.elementsNamed("gamesounds")) {
			for (entry in section.elements()) {
				soundNames.push(entry.nodeName.toUpperCase());
				soundsFiles.push(elementText(entry));
			}
		}
		for (section in root.elementsNamed("dungeonmusic")) {
			for (entry in section.elements()) {
				dungeonMusicNames.push(entry.nodeName.toUpperCase());
				dungeonMusicFiles.push(elementText(entry));
			}
		}
		trace("sounds.xml: " + soundNames.length + " game sounds, " + dungeonMusicNames.length + " dungeon tracks");
		soundsIndex = 0;
		setContinueLoading();
		loadGameSound();
	}

	function dragEffectsVol(param1:Event):Void {
		var _loc2_:Rectangle = null;
		_loc2_ = new Rectangle(0, 0, effectsVolumeBarMC.backMC.width - effectsVolumeBarMC.sliderMC.width, 0);
		effectsVolumeBarMC.sliderMC.startDrag(false, _loc2_);
		draggingEffectsVol = true;
		effectsVolumeBarMC.sliderMC.addEventListener(Event.ENTER_FRAME, adjustEffectsVol);
	}

	function dropEffectsVol(param1:Event):Void {
		if (draggingEffectsVol) {
			effectsVolumeBarMC.sliderMC.stopDrag();
			effectsVolumeBarMC.sliderMC.removeEventListener(Event.ENTER_FRAME, adjustEffectsVol);
			draggingEffectsVol = false;
			game.userSharedObject.data.effectsVolume = effectsTransform.volume;
			game.userSharedObject.flush();
		}
	}

	function finishContinueLoadingForDungeon():Void {
		// AS3 clearInterval() on an unset interval was a no-op; Timer.stop() on null segfaults.
		if (continueLoadingIntervalForDungeonTimer != null) {
			continueLoadingIntervalForDungeonTimer.stop();
			continueLoadingIntervalForDungeonTimer = null;
		}
		//clearInterval(continueLoadingIntervalForDungeon);
	}

	function chackContinueLoadingNeeded():Void {
		trace("loadingCounter:" + loadingCounter);
		if (lastLoadingCounter == loadingCounter) {
			continueLoading();
		} else {
			lastLoadingCounter = loadingCounter;
		}
	}

	public function setMusicVolumeBar(volumeBar:VolumeBar_8):Void {
		musicVolumeBarMC = volumeBar;
		draggingMusicVol = false;
		musicVolumeBarMC.sliderMC.x = musicTransform.volume * (musicVolumeBarMC.backMC.width - musicVolumeBarMC.sliderMC.width);
		musicVolumeBarMC.maskMC.width = musicVolumeBarMC.sliderMC.x + musicVolumeBarMC.sliderMC.width;
		musicVolumeBarMC.sliderMC.addEventListener(MouseEvent.MOUSE_DOWN, dragMusicVol);
		musicVolumeBarMC.sliderMC.buttonMode = true;
		musicVolumeBarMC.sliderMC.tabEnabled = false;
		game.stage.addEventListener(MouseEvent.MOUSE_UP, dropMusicVol);
	}

	function adjustMusicVol(_:Event):Void {
		var volume = musicVolumeBarMC.sliderMC.x / (musicVolumeBarMC.backMC.width - musicVolumeBarMC.sliderMC.width);
		musicVolumeBarMC.maskMC.width = musicVolumeBarMC.sliderMC.x + musicVolumeBarMC.sliderMC.width;
		setMusicVolume(volume);
	}

	public function playMusic(param1:String):Void {
		var _loc2_:SoundChannel = null;
		var param:Sound = soundLibrary.get(param1);
		if (currMusicName != param1) {
			stopMusic();
			if (param != null) {
				currMusicName = param1;
				_loc2_ = param.play(0, 1000, musicTransform);
				if (_loc2_ != null) musicArray.push(_loc2_);
			}
		}
	}

	public function stopMusic():Void {
		var _loc1_:SoundChannel = null;
		while (musicArray.length > 0) {
			_loc1_ = musicArray.pop();
			_loc1_.stop();
			_loc1_ = null;
			currMusicName = "";
		}
	}

	function chackContinueLoadingNeededForDungeon():Void {
		trace("loadingCounterForDungeon:" + loadingCounterForDungeon);
		if (lastLoadingCounterForDungeon == loadingCounterForDungeon) {
			continueLoadingForDungeon();
		} else {
			lastLoadingCounterForDungeon = loadingCounterForDungeon;
		}
	}

	function adjustEffectsVol(_:Event):Void {
		var volume = effectsVolumeBarMC.sliderMC.x / (effectsVolumeBarMC.backMC.width - effectsVolumeBarMC.sliderMC.width);
		effectsVolumeBarMC.maskMC.width = effectsVolumeBarMC.sliderMC.x + effectsVolumeBarMC.sliderMC.width;
		setEffectsVolume(volume);
	}

	// Typed channels: through a Dynamic, `.soundTransform = …` is reflective and throws
	// "Invalid field:soundTransform" on hxcpp - which the volume sliders hit on every drag.
	function setEffectsVolume(volume:Float):Void {
		effectsTransform.volume = volume;
		for (channel in effectsArray) {
			channel.soundTransform = effectsTransform;
		}
		for (channel in loopEffectsArray) {
			channel.soundTransform = effectsTransform;
		}
	}

	function loadDungeonMusic():Void {
		var _loc1_:String = null;
		++loadingCounterForDungeon;
		if (dungeonMusicIndex < currDungeonMusicNames.length) {
			_loc1_ = currDungeonMusicNames[dungeonMusicIndex];
			var music:Sound = soundLibrary.get(_loc1_);
			if (music == null) {
				MsgBox.updateWaitBoxTxt(game.gameData.dictionary.LOADING_DUNGEON_MUSIC_MSG);
				var trackCount = currDungeonMusicNames.length;
				var trackIndex = dungeonMusicIndex;
				loadSoundAsset(_loc1_, game.gameLoader.soundsPath + "/" + currDungeonMusicFiles[dungeonMusicIndex],
					function(pct:Float):Void {
						++loadingCounterForDungeon;
						MsgBox.updateWaitBox(Math.floor(pct / trackCount + 100 / trackCount * trackIndex));
					},
					loadDungeonMusicCompleteNoEvent);
			} else {
				loadDungeonMusicCompleteNoEvent();
			}
		} else {
			trace("finish DungeonMusic load");
			finishContinueLoadingForDungeon();
			game.finishDungeonMusicLoad();
		}
	}

	function finishContinueLoading():Void {
		// AS3 clearInterval() on an unset interval was a no-op; Timer.stop() on null segfaults.
		if (continueLoadingIntervalTimer != null) {
			continueLoadingIntervalTimer.stop();
			continueLoadingIntervalTimer = null;
		}
		// clearInterval(continueLoadingInterval);
	}

	public function playLoopEffect(param1:String):Void {
		var _loc2_:SoundChannel = null;
		var sound:Sound = soundLibrary.get(param1);
		if (param1 != "") {
			if (sound != null) {
				_loc2_ = sound.play(0, 100, effectsTransform);
				if (_loc2_ != null) loopEffectsArray.push(_loc2_);
			}
		}
	}

	function effectCompleted(param1:Event):Void {
		var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		_loc2_ = 0;
		while (_loc2_ < effectsArray.length) {
			if (effectsArray[_loc2_] == param1.target) {
				_loc3_ = effectsArray.splice(_loc2_, 1);
				_loc3_ = null;
				break;
			}
			_loc2_++;
		}
	}

	function setContinueLoading():Void {
		loadingCounter = 0;
		lastLoadingCounter = 0;
		continueLoadingIntervalTimer = new Timer(3000);
		continueLoadingIntervalTimer.run = chackContinueLoadingNeeded;
		// continueLoadingInterval = setInterval(chackContinueLoadingNeeded, 3000);
	}

	function setContinueLoadingForDungeon():Void {
		loadingCounterForDungeon = 0;
		lastLoadingCounterForDungeon = 0;
		continueLoadingIntervalForDungeonTimer = new Timer(3000);
		continueLoadingIntervalForDungeonTimer.run = chackContinueLoadingNeededForDungeon;
		// continueLoadingIntervalForDungeon = setInterval(chackContinueLoadingNeededForDungeon, 3000);
	}

	function loadGameSound():Void {
		var _loc1_:String = null;
		++loadingCounter;
		if (soundsIndex < soundNames.length) {
			_loc1_ = soundNames[soundsIndex];
			loadSoundAsset(_loc1_, game.gameLoader.soundsPath + "/" + soundsFiles[soundsIndex],
				function(pct:Float):Void { ++loadingCounter; },
				function():Void { ++soundsIndex; loadGameSound(); });
		} else {
			trace("finish sound load");
			finishContinueLoading();
		}
	}

	function dragMusicVol(param1:Event):Void {
		var _loc2_:Rectangle = null;
		_loc2_ = new Rectangle(0, 0, musicVolumeBarMC.backMC.width - musicVolumeBarMC.sliderMC.width, 0);
		musicVolumeBarMC.sliderMC.startDrag(false, _loc2_);
		draggingMusicVol = true;
		musicVolumeBarMC.sliderMC.addEventListener(Event.ENTER_FRAME, adjustMusicVol);
	}

	function setMusicVolume(volume:Float):Void {
		musicTransform.volume = volume;
		for (channel in musicArray) {
			channel.soundTransform = musicTransform;
		}
	}
}
