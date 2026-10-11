package utils;

import motion.Actuate;
import motion.easing.Quad;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.display.PixelSnapping;
import openfl.display.Stage;
import openfl.events.Event;
import openfl.utils.Assets;

/**
	Studio splash before anything else is drawn. Hides the game sprite while playing, fades
	from the stage's black background up to a full-opacity logo, holds, fades back out,
	restores the game and calls `onDone`.

	Sits on the Stage directly rather than on the game sprite, so BambaMain's scrollRect
	and fitToStage scale do not clip or distort it. Loading in BambaLoader keeps running
	underneath, so by the time the splash fades the opening screen (or loading bar) is
	already warm and shown first - nothing visually leaks around the splash's letterbox.
**/
class StudioIntro {
	// Playback timing, in seconds. Total ~4.1s - a slower, more cinematic reveal of
	// "LONE WHALE" without making the player wait on a boot screen.
	static inline var FADE_IN = 0.8;
	static inline var HOLD = 2.5;
	static inline var FADE_OUT = 0.8;

	/**
		Hide `cover`, play the splash on `stage`, restore `cover`, call `onDone`. `cover` is
		typically the game sprite (BambaMain), so the loading screen it builds does not peek
		around the splash's black bars on a non-16:9 window.
	**/
	public static function play(stage:Stage, cover:DisplayObject, onDone:Void->Void):Void {
		if (stage == null) {
			if (onDone != null) onDone();
			return;
		}
		var data = try Assets.getBitmapData("assets/splash.png") catch (_:Dynamic) null;
		if (data == null) {
			trace("StudioIntro: splash asset missing, skipping");
			if (onDone != null) onDone();
			return;
		}
		// Hide the game while the splash plays; its black stage background remains visible
		// outside the splash's own letterboxed logo. Restored before onDone fires.
		var coverWasVisible = true;
		if (cover != null) {
			coverWasVisible = cover.visible;
			cover.visible = false;
		}

		var bitmap = new Bitmap(data, PixelSnapping.AUTO, true);
		layout(bitmap, stage);
		bitmap.alpha = 0;
		stage.addChild(bitmap);

		// Re-layout on resize so the splash stays centred and sized to the window.
		var onResize:Event->Void = null;
		onResize = function(_) layout(bitmap, stage);
		stage.addEventListener(Event.RESIZE, onResize);

		Actuate.tween(bitmap, FADE_IN, {alpha: 1}).ease(Quad.easeInOut).onComplete(function() {
			Actuate.timer(HOLD).onComplete(function() {
				Actuate.tween(bitmap, FADE_OUT, {alpha: 0}).ease(Quad.easeInOut).onComplete(function() {
					stage.removeEventListener(Event.RESIZE, onResize);
					if (bitmap.parent != null) bitmap.parent.removeChild(bitmap);
					if (cover != null) cover.visible = coverWasVisible;
					if (onDone != null) onDone();
				});
			});
		});
	}

	// Centre the splash on the stage and scale it uniformly to fit (contain-style, so no
	// crop). The source is on a solid black background, which blends into the stage's own
	// black so there is no visible letterbox.
	static function layout(bitmap:Bitmap, stage:Stage):Void {
		if (bitmap.bitmapData == null) return;
		var sw = stage.stageWidth;
		var sh = stage.stageHeight;
		var bw = bitmap.bitmapData.width;
		var bh = bitmap.bitmapData.height;
		var scale = Math.min(sw / bw, sh / bh);
		bitmap.scaleX = bitmap.scaleY = scale;
		bitmap.x = (sw - bw * scale) / 2;
		bitmap.y = (sh - bh * scale) / 2;
	}
}
