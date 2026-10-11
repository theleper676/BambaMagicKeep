package utils;

import swf.exporters.animate.AnimateBitmapSymbol;
import swf.exporters.animate.AnimateLibrary;
import swf.exporters.animate.AnimateShapeSymbol;

/**
	Turns on bilinear filtering for every bitmap in a loaded SWF library.

	The original Flash artwork was authored at 1:1 and almost all of it is marked
	*non-smoothed* - 291 of the 356 bitmap symbols across this project carry `smooth: false`
	in the generated data.json, as do 94 of the 96 bitmap fills inside shapes. That was the
	right choice in Flash, where the stage never scaled; the exporter faithfully preserves it,
	and OpenFL honours it literally:

	  - `AnimateBitmapSymbol.__createObject()` builds `new Bitmap(..., smooth != false)`, so
	    `smooth: false` gives `Bitmap.smoothing == false`.
	  - `AnimateShapeSymbol.__createObject()` forwards the flag to
	    `Graphics.beginBitmapFill(..., smooth)`.

	Either way the GL renderer picks its texture filter with
	`(smooth && __allowSmoothing) ? LINEAR : NEAREST` (OpenGLRenderer), so an unsmoothed bitmap
	is point-sampled. Now that BambaMain scales the whole display tree to the window that means
	visibly blocky, aliased edges at any scale other than exactly 1.0.

	Flipping the flag to `true` costs nothing - it is the same texture, sampled bilinearly - and
	is the only knob that covers bitmap *fills* inside shapes, which the renderer's own
	`__upscaled` fallback (Context3DBitmap) does not reach.

	Order matters: both `__createObject()` implementations read these fields when a symbol is
	first instantiated, and `AnimateShapeSymbol` then nulls `commands` and caches the result in
	`rendered`. So this has to run on a freshly loaded library, before anything is built from it -
	the same point in the load where `SymbolClassBinder.bind()` already rewrites class names.
**/
@:access(swf.exporters.animate)
class BitmapSmoothing {
	public static function apply(library:AnimateLibrary):Void {
		if (library == null) return;
		var bitmaps = 0;
		var fills = 0;
		for (symbol in library.symbols) {
			if (symbol == null) continue;
			if (Std.isOfType(symbol, AnimateBitmapSymbol)) {
				var bitmapSymbol:AnimateBitmapSymbol = cast symbol;
				if (bitmapSymbol.smooth != true) {
					bitmapSymbol.smooth = true;
					bitmaps++;
				}
			} else if (Std.isOfType(symbol, AnimateShapeSymbol)) {
				var shapeSymbol:AnimateShapeSymbol = cast symbol;
				// null once the shape has been instantiated: its graphics are already cached in
				// `rendered` and re-issuing the commands would no longer change anything.
				if (shapeSymbol.commands == null) continue;
				for (i in 0...shapeSymbol.commands.length) {
					switch (shapeSymbol.commands[i]) {
						case BeginBitmapFill(bitmapID, matrix, repeat, smooth):
							if (!smooth) {
								shapeSymbol.commands[i] = BeginBitmapFill(bitmapID, matrix, repeat, true);
								fills++;
							}
						default:
					}
				}
			}
		}
		trace("BitmapSmoothing " + (library.uuid != null ? library.uuid : library.id)
			+ ": smoothed " + bitmaps + " bitmap symbols, " + fills + " bitmap fills");
	}
}
