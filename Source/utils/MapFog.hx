package utils;

import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.utils.Assets;

/**
	Puts back the fog over map areas 2-6.

	In mapGraphics.swf each of those areas' "blind_map_*" clips is an embedded VP6-alpha
	video: timeline frame N shows video frame N-1, so "hide" (frame 1) is the full fog,
	"show-anim" plays the fog clearing and "show" (frame 51) drops the video. The swf
	exporter cannot export video, so the clips came out empty and those areas were always
	uncovered. The frames were decoded to Assets/map_fog/<area>/NN.png with
	tools/extract_fog.py and ffmpeg; this shows the matching one for the clip's frame.

	Area 1 (the castle) is a morph-shape mask instead of a video, also dropped by the
	exporter - but area 1 is always revealed, so it never needs its fog.
**/
class MapFog {
	static inline var VIDEO_FRAMES = 50;

	/** Where each video sits inside its area clip (the PlaceObject matrix in the SWF). **/
	static final OFFSETS:Map<String, Array<Float>> = [
		"area2MC" => [160.7, 212.35],
		"area3MC" => [275.9, -20.25],
		"area4MC" => [-3.9, 233.6],
		"area5MC" => [-4.0, -8.2],
		"area6MC" => [469.4, 77.75]
	];

	public static function attach(area:MovieClip, name:String):Void {
		var offset = OFFSETS.get(name);
		if (area == null || offset == null) return;
		// Frame 0 is shown whenever the area is hidden, so it stays cached; the reveal frames
		// play once per area per game and are loaded uncached rather than kept in memory.
		var fog = frame(name, 0, true);
		if (fog == null) return;
		var bitmap = new Bitmap(fog);
		bitmap.smoothing = true;
		bitmap.x = offset[0];
		bitmap.y = offset[1];
		area.addChild(bitmap);
		var shown = 0;
		var sync = function(_):Void {
			var videoFrame = area.currentFrame - 1;
			bitmap.visible = videoFrame < VIDEO_FRAMES;
			if (bitmap.visible && videoFrame != shown) {
				var data = videoFrame == 0 ? fog : frame(name, videoFrame, false);
				if (data != null) bitmap.bitmapData = data;
				shown = videoFrame;
			}
		};
		area.addEventListener(Event.ENTER_FRAME, sync);
		sync(null);
	}

	static function frame(name:String, index:Int, cache:Bool):BitmapData {
		var id = "assets/map_fog/" + name + "/" + (index < 10 ? "0" : "") + index + ".png";
		if (!Assets.exists(id)) {
			trace("MapFog: missing " + id);
			return null;
		}
		return Assets.getBitmapData(id, cache);
	}
}
