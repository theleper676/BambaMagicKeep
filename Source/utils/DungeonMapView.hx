package utils;

import openfl.display.MovieClip;

/**
	A dungeon's "dungeonMap" clip, from whichever dungeonN library is loaded.

	Every dungeon library exports its map under the same class name with the same two layers
	(`lowerMC` under the walls, `uperMC` above them), but only dungeon4 has a generated Haxe
	class, so the map is a plain MovieClip and the layers are looked up by name.
**/
@:forward
abstract DungeonMapView(MovieClip) from MovieClip to MovieClip {
	public var lowerMC(get, never):MovieClip;
	public var uperMC(get, never):MovieClip;

	inline function get_lowerMC():MovieClip {
		return cast this.getChildByName("lowerMC");
	}

	inline function get_uperMC():MovieClip {
		return cast this.getChildByName("uperMC");
	}
}
