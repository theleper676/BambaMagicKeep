package general;

import openfl.display.MovieClip;
import openfl.events.MouseEvent;

class ButtonUpdater {
	public static function setButton (clip:MovieClip, listener: MouseEvent -> Void):Void {
		if(clip != null) {
		clip.addEventListener(MouseEvent.CLICK, listener);
	}
		clip.addEventListener(MouseEvent.ROLL_OVER, onRollOverWrapper);
		clip.addEventListener(MouseEvent.ROLL_OUT, onRollOutWrapper);
		clip.buttonMode = true;
		clip.tabEnabled = false;
		clip.gotoAndStop(1);
	}


private static function onRollOverWrapper(e:MouseEvent):Void {
    onRollOver(cast(e.currentTarget, MovieClip));
}

private static function onRollOutWrapper(e:MouseEvent):Void {
    onRollOut(cast(e.currentTarget, MovieClip));
}

	public static function onRollOver (clip:MovieClip):Void {
		clip.gotoAndStop(2);
	}

	public static function onRollOut(clip:MovieClip):Void {
		clip.gotoAndStop(1);
	}
	public static function buttonRollOver(param1:MouseEvent):Void {
		param1.currentTarget.gotoAndStop(2);
	}

	public static function clearEvents(clip:MovieClip, listener: MouseEvent -> Void):Void {
		clip.removeEventListener(MouseEvent.CLICK, listener);
		clip.removeEventListener(MouseEvent.ROLL_OVER, onRollOverWrapper);
		clip.removeEventListener(MouseEvent.ROLL_OUT, onRollOutWrapper);
	}

	public static function buttonRollOut(param1:MouseEvent):Void {
		param1.currentTarget.gotoAndStop(1);
	}
}
