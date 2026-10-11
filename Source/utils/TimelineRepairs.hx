package utils;

import haxe.ds.IntMap;
import swf.exporters.animate.AnimateFrameObject;
import swf.exporters.animate.AnimateLibrary;
import swf.exporters.animate.AnimateSpriteSymbol;

/**
	Load-time repairs to converted timelines, for two places where OpenFL's playback differs
	from Flash. Run on every library before anything is instantiated from it.

	**Mask layers are drawn.** Flash never draws a mask layer. OpenFL only stops drawing a
	mask while some object below it is actually masked, so a mask on a frame with nothing
	under it shows up as a solid shape. The baby's attack effects rest on such a frame: their
	first frame holds only a mask, so a full-board teal rectangle (natureAttack10MC's mask)
	covered the fight background and the baby. Every mask object is created hidden here.
	OpenFL's mask renderer ignores `visible`, so hidden masks still clip.

	**Swapped drawings lose their state.** Frame-by-frame animation (fog and birds over a
	fight background, the baby's moves) often swaps the symbol at a depth without re-sending
	its position, tint or filters, which in Flash carry over. The swf exporter turns each swap
	into "destroy, then create" and keeps only what the swap sent, so the new piece comes up
	untinted, or at 0,0 with no matrix (669 times in dungeon5's art alone). Each create that
	replaces an object destroyed at the same depth in the same frame gets the old object's
	matrix, tint, filters and blend mode.
**/
@:access(swf.exporters.animate)
class TimelineRepairs {
	public static function apply(library:AnimateLibrary):Void {
		if (library == null || library.symbols == null) return;
		var masks = 0;
		var replaced = 0;
		for (symbol in library.symbols) {
			if (!Std.isOfType(symbol, AnimateSpriteSymbol)) continue;
			var sprite:AnimateSpriteSymbol = cast symbol;
			if (sprite.frames == null) continue;
			// The latest state of each live object, by frame-object id.
			var live = new IntMap<AnimateFrameObject>();
			for (frame in sprite.frames) {
				if (frame.objects == null) continue;
				var destroyed = new IntMap<Bool>();
				for (object in frame.objects) {
					if (object.type == DESTROY) destroyed.set(object.id, true);
				}
				var ownerAtDepth = new IntMap<AnimateFrameObject>();
				for (state in live) ownerAtDepth.set(state.depth, state);
				for (object in frame.objects) {
					switch (object.type) {
						case CREATE:
							if (object.clipDepth > 0 && object.visible == null) {
								object.visible = false;
								masks++;
							}
							var previous = ownerAtDepth.get(object.depth);
							if (previous != null && destroyed.exists(previous.id) && inherit(object, previous)) replaced++;
							live.set(object.id, snapshot(object));
						case UPDATE:
							var state = live.get(object.id);
							if (state != null) merge(state, object);
						case DESTROY:
					}
				}
				for (id in destroyed.keys()) live.remove(id);
			}
		}
		if (masks + replaced > 0) trace("TimelineRepairs " + library.uuid + ": hid " + masks + " masks, restored " + replaced + " swapped objects");
	}

	static function inherit(object:AnimateFrameObject, previous:AnimateFrameObject):Bool {
		var changed = false;
		if (object.matrix == null && previous.matrix != null) {
			object.matrix = previous.matrix.clone();
			changed = true;
		}
		if (object.colorTransform == null && previous.colorTransform != null) {
			object.colorTransform = previous.colorTransform;
			changed = true;
		}
		if (object.filters == null && previous.filters != null) {
			object.filters = previous.filters;
			changed = true;
		}
		if (object.blendMode == null && previous.blendMode != null) {
			object.blendMode = previous.blendMode;
			changed = true;
		}
		return changed;
	}

	static function snapshot(object:AnimateFrameObject):AnimateFrameObject {
		var state = new AnimateFrameObject();
		state.id = object.id;
		state.depth = object.depth;
		merge(state, object);
		return state;
	}

	static function merge(state:AnimateFrameObject, object:AnimateFrameObject):Void {
		if (object.matrix != null) state.matrix = object.matrix;
		if (object.colorTransform != null) state.colorTransform = object.colorTransform;
		if (object.filters != null) state.filters = object.filters;
		if (object.blendMode != null) state.blendMode = object.blendMode;
	}
}
