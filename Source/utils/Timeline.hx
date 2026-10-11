package utils;

import openfl.display.MovieClip;
import openfl.events.Event;

/**
	Plays a labelled span of a timeline and stops at its end.

	Flash timelines halted themselves with AS3 frame scripts. The swf exporter does capture
	frame scripts, but the ones in this project are `this.addFrameScript(0, frame1)` - calls
	into AS3 document-class methods (`frame1`, ...) that do not exist after the port, so the
	actual `stop()` never happens. The result is that any `gotoAndPlay("label")` runs off the
	end of its animation and loops forever.

	`playSegment` derives the end of a span from the timeline's own labels: the frame before
	the next label, or the last frame when the label is the final one.

	Only use this for one-shot animations. Clips that are *meant* to loop (idle animations and
	the like) should keep calling `gotoAndPlay` directly.
**/
class Timeline {
	// One active watcher per clip, so starting a new segment cancels the previous one instead
	// of letting a stale listener stop the clip mid-animation.
	static var watchers:Map<MovieClip, Event->Void> = new Map();

	public static function playSegment(clip:MovieClip, label:String, ?onComplete:Void->Void):Void {
		if (clip == null) {
			return;
		}
		var start = -1;
		for (frameLabel in clip.currentLabels) {
			if (frameLabel.name == label) {
				start = frameLabel.frame;
				break;
			}
		}
		if (start < 0) {
			trace("Timeline: no frame label '" + label + "' on this clip - playing from the start");
			start = 1;
		}
		var end = clip.totalFrames;
		for (frameLabel in clip.currentLabels) {
			if (frameLabel.frame > start && frameLabel.frame - 1 < end) {
				end = frameLabel.frame - 1;
			}
		}
		stopAtFrame(clip, start, end, onComplete);
	}

	public static function cancel(clip:MovieClip):Void {
		var watcher = watchers.get(clip);
		if (watcher != null) {
			clip.removeEventListener(Event.ENTER_FRAME, watcher);
			watchers.remove(clip);
		}
	}

	static function stopAtFrame(clip:MovieClip, start:Int, end:Int, onComplete:Void->Void):Void {
		cancel(clip);
		var watcher:Event->Void = null;
		watcher = function(_):Void {
			if (clip.currentFrame >= end) {
				cancel(clip);
				clip.gotoAndStop(end);
				if (onComplete != null) {
					onComplete();
				}
			}
		};
		watchers.set(clip, watcher);
		clip.addEventListener(Event.ENTER_FRAME, watcher);
		clip.gotoAndPlay(start);
	}
}
