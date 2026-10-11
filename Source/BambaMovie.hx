package;

import general_assets.SkipButton;
import openfl.display.*;
import openfl.events.*;
import openfl.external.ExternalInterface;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.utils.Assets;
import openfl.net.URLRequest;
import general.ButtonUpdater;
import general.MsgBox;
import swf.exporters.animate.AnimateLibrary;

class BambaMovie {
	// Typed, not Dynamic: Dynamic makes every .play()/.currentFrame access reflective, which
	// throws "Invalid field:..." on hxcpp once DCE has trimmed the reflection entries.
	var movieMC:MovieClip;
	var skipButton:SkipButton;

	// The intro's soundtrack is a *streamed* MP3 inside IntroBamba.swf (SoundStreamHead /
	// SoundStreamBlock). The swf exporter only converts event sounds (TagDefineSound), so the
	// track is absent from the generated library - and lime cannot decode MP3 natively anyway.
	// It was extracted with ffmpeg to an OGG that plays alongside the timeline.
	static inline var INTRO_SOUND = "assets/intro/IntroBamba.ogg";

	/**
		Milliseconds to skip into the soundtrack when it starts, to compensate for any residual
		audio/video drift. Raise it if the sound still trails the picture, lower it if it runs
		ahead. 0 means start from the beginning.
	**/
	static inline var INTRO_SOUND_OFFSET_MS = 0;

	/**
		The intro library once loaded, and whether a load is under way. The AS3 version had a
		stall watchdog that re-ran the whole load whenever no progress event arrived for a few
		seconds; it leaked a timer on every retry, so stray reloads kept popping the movie back
		up over the menu after it ended. AnimateLibrary loads either complete or fail, so the
		watchdog is gone.
	**/
	static var introLibrary:AnimateLibrary;

	var loading = false;

	var introSound:Sound;
	var introChannel:SoundChannel;


	
	var game:BambaMain;

	
	var assetFileName:String;

	public function new(mainGame:BambaMain) {
		game = mainGame;
	}

	
	function checkEnd(param1:Event):Void {
		if (skipButton != null) {
			movieMC.setChildIndex(skipButton, movieMC.numChildren - 1);
		}
		if (movieMC.currentFrame == movieMC.totalFrames) {
			stopMovie();
			game.endMovie(movieMC);
		} else {
			// OpenFL leaves Sprite.soundTransform unimplemented (commented out in openfl/display/Sprite.hx),
			// so a clip's audio cannot be routed this way. Was reflective (Dynamic) before and would have thrown.
			// movieMC.soundTransform = game.sound.musicTransform;
		}
	}

	

	
	public function stopMovie():Void {
		var _loc1_:SoundTransform = null;
		if (introChannel != null) {
			introChannel.stop();
			introChannel = null;
		}
		if (movieMC != null) {
			movieMC.gotoAndStop(movieMC.totalFrames);
			movieMC.removeEventListener(Event.ENTER_FRAME, checkEnd);
			// OpenFL leaves Sprite.soundTransform unimplemented (commented out in openfl/display/Sprite.hx),
			// so a clip's audio cannot be routed this way. Was reflective (Dynamic) before and would have thrown.
			// _loc1_ = new SoundTransform();
			// _loc1_.volume = 0;
			// movieMC.soundTransform = _loc1_;
		}
	}

	

	

	
	function skipButtonClicked(param1:MouseEvent):Void {
		movieMC.gotoAndPlay(movieMC.totalFrames);
	}

	
	
	public function setMovieAsset(movieAssetPath:Dynamic):Void {
		assetFileName = movieAssetPath;
	}

	

	

	

	/**
		The intro used to be a raw SWF pulled in with `Loader.load()`. On native targets OpenFL
		has no runtime SWF parser - the bytes loaded fine but `Event.INIT` never produced content,
		so `loader.content` was null and the wait box sat at 0 forever (the AS3 original had no
		IO error handler either). `swf`'s own AnimateLoader is still a stub.

		IntroBamba.swf is now converted to an OpenFL/animate library with
		`haxelib run swf generate`, the same form every other SWF in this project already uses,
		and loaded through AnimateLibrary. The movie is the library's root timeline.
	**/
	public function loadAndShow():Void {
		// One load at a time, and only once: the 4MB library is kept for the next showing.
		if (loading) return;
		if (introLibrary != null) {
			showFromLibrary(introLibrary);
			return;
		}
		loading = true;
		MsgBox.showWaitBox(game.gameData.dictionary.LOADING_MOVIE_MSG);
		AnimateLibrary.loadFromFile(assetFileName)
			.onProgress((bytesLoaded, bytesTotal) -> {
				if (bytesTotal > 0) {
					MsgBox.updateWaitBox(Math.floor(bytesLoaded / bytesTotal * 100));
				}
			})
			.onError((error) -> {
				trace("BambaMovie: intro library failed to load: " + error);
				loading = false;
				movieUnavailable();
			})
			.onComplete((library) -> {
				utils.SymbolClassBinder.bind(library);
				utils.BitmapSmoothing.apply(library);
				utils.FontBinder.apply(library);
				loading = false;
				introLibrary = library;
				showFromLibrary(library);
			});
	}

	function showFromLibrary(library:AnimateLibrary):Void {
		movieMC = library.getMovieClip("");
		showLoadedMovie();
	}

	function showLoadedMovie():Void {
		if (movieMC == null) {
			MsgBox.closeWaitBox();
			trace("BambaMovie: intro library has no root timeline - skipping");
			game.endMovie(null);
			return;
		}
		// Decode the soundtrack up front, while the wait box is still showing. Assets.loadMusic()
		// hands back a *streamed* VorbisFile buffer, and priming that stream costs enough at
		// start-up that the audio noticeably trails the picture. AudioBuffer.fromBytes decodes
		// the whole track into memory instead, so play() is immediate.
		introSound = decodeIntroSound();
		startLoadedMovie();
	}

	function decodeIntroSound():Sound {
		if (!Assets.exists(INTRO_SOUND)) {
			trace("BambaMovie: intro soundtrack missing from manifest: " + INTRO_SOUND);
			return null;
		}
		try {
			var bytes:haxe.io.Bytes = Assets.getBytes(INTRO_SOUND);
			if (bytes == null) return null;
			var buffer = lime.media.AudioBuffer.fromBytes(bytes);
			if (buffer == null) {
				trace("BambaMovie: could not decode intro soundtrack");
				return null;
			}
			return Sound.fromAudioBuffer(buffer);
		} catch (e:Dynamic) {
			trace("BambaMovie: error decoding intro soundtrack: " + e);
			return null;
		}
	}

	function startLoadedMovie():Void {
		MsgBox.closeWaitBox();
		movieMC.addEventListener(Event.ENTER_FRAME, checkEnd);
		movieMC.stop();
		skipButton = new SkipButton();
		skipButton.x = 380;
		skipButton.y = 480;
		movieMC.addChild(skipButton);
		ButtonUpdater.setButton(skipButton, skipButtonClicked);
		game.showMovie(movieMC);
		// Start the audio before the timeline: movieMC.play() only flags it as playing, and the
		// first frame does not advance until the next ENTER_FRAME.
		if (introSound != null) {
			introChannel = introSound.play(INTRO_SOUND_OFFSET_MS, 0, game.sound.musicTransform);
		}
		movieMC.play();
	}

	// Continue into the game rather than leaving the player stuck behind a wait box.
	function movieUnavailable():Void {
		MsgBox.closeWaitBox();
		game.endMovie(null);
	}
}
