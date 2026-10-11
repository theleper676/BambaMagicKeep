package utils;

import openfl.display.MovieClip;
import swf.exporters.animate.AnimateLibrary;
import swf.exporters.animate.AnimateSpriteSymbol;

/**
	Turns a library's one-line frame scripts back into real frame scripts.

	The swf library only runs `scriptSource` through hscript, which this project does not
	compile in, so `this.stop();` and `this.gotoAndPlay(1);` at the end of each animation never
	run and every clip loops through all its moves. The dungeon and enemy libraries use nothing
	but those two (plus the gotoAndStop form), so they are parsed here and set as `frame.script`,
	which the timeline runs directly.

	Only for libraries whose scripts are known to be this simple: the older libraries carry
	`addFrameScript(0, frame1)` document-class calls instead (see utils.Timeline). Anything
	unrecognised is left alone and reported.
**/
@:access(swf.exporters.animate)
class FrameScripts {
	static final CALL = ~/^this\.(stop|play|gotoAndPlay|gotoAndStop)\((?:(\d+)|"([^"]*)")?\);$/;

	public static function restore(library:AnimateLibrary):Void {
		if (library == null || library.symbols == null) return;
		var restored = 0;
		var unknown = 0;
		for (symbol in library.symbols) {
			if (!Std.isOfType(symbol, AnimateSpriteSymbol)) continue;
			var sprite:AnimateSpriteSymbol = cast symbol;
			if (sprite.frames == null) continue;
			for (frame in sprite.frames) {
				if (frame.script != null || frame.scriptSource == null) continue;
				var script = parse(StringTools.trim(frame.scriptSource));
				if (script != null) {
					frame.script = script;
					restored++;
				} else {
					unknown++;
				}
			}
		}
		trace("FrameScripts " + library.uuid + ": restored " + restored + (unknown > 0 ? ", left " + unknown + " unrecognised" : ""));
	}

	static function parse(source:String):MovieClip->Void {
		if (!CALL.match(source)) return null;
		var method = CALL.matched(1);
		var number = CALL.matched(2);
		var target:Dynamic = number != null ? Std.parseInt(number) : CALL.matched(3);
		return switch (method) {
			case "stop": clip -> clip.stop();
			case "play": clip -> clip.play();
			case "gotoAndPlay" if (target != null): clip -> clip.gotoAndPlay(target);
			case "gotoAndStop" if (target != null): clip -> clip.gotoAndStop(target);
			default: null;
		}
	}
}
