package utils;

#if (debug && sys)
import haxe.Timer;
import openfl.display.BitmapData;
import openfl.display.PNGEncoderOptions;
import openfl.display.Stage;
import sys.FileSystem;
import sys.io.File;
#end

/**
	Debug builds only: saves a burst of stage screenshots to `captures/` next to the project,
	so visual glitches (flicker, missing layers) can be inspected frame by frame.
	F9 starts a burst at any time (see `install`). Release builds compile this to nothing.
**/
class DebugCapture {
	#if (debug && sys)
	static inline var DIR = "F:/BambaMagicKeep/captures";

	static var timer:Timer;
	static var keyHooked = false;
	#end

	/** Debug builds: lets F9 record a burst. Nothing records until it is pressed. **/
	public static function install(stage:Dynamic):Void {
		#if (debug && sys)
		if (stage != null) hookKey(cast stage);
		#end
	}

	public static function burst(stage:Dynamic, label:String, count:Int = 40, intervalMs:Int = 150):Void {
		#if (debug && sys)
		var stage:Stage = cast stage;
		if (stage == null || timer != null) return;
		hookKey(stage);
		try FileSystem.createDirectory(DIR) catch (_:Dynamic) {}
		var shot = 0;
		timer = new Timer(intervalMs);
		timer.run = function() {
			try {
				var bmp = new BitmapData(stage.stageWidth, stage.stageHeight, false, 0xFF00FF);
				bmp.draw(stage);
				var bytes = bmp.encode(bmp.rect, new PNGEncoderOptions());
				File.saveBytes(DIR + "/" + label + "_" + StringTools.lpad(Std.string(shot), "0", 3) + ".png", bytes);
				bmp.dispose();
			} catch (e:Dynamic) {
				trace("DebugCapture failed: " + e);
			}
			if (++shot >= count) {
				timer.stop();
				timer = null;
				trace("DebugCapture: saved " + count + " shots '" + label + "'");
			}
		};
		#end
	}

	#if (debug && sys)
	static function hookKey(stage:Stage):Void {
		if (keyHooked) return;
		keyHooked = true;
		var n = 0;
		stage.addEventListener(openfl.events.KeyboardEvent.KEY_DOWN, function(e:openfl.events.KeyboardEvent) {
			if (e.keyCode == openfl.ui.Keyboard.F9) burst(stage, "key" + (n++));
		});
	}
	#end
}
