package utils;

import swf.exporters.animate.AnimateLibrary;
import swf.utils.SymbolUtils;

/**
	Makes the generated SWF symbol classes resolvable at runtime.

	The swf exporter wrote each SWF's generated symbol classes into their own Haxe package
	(general.swf -> `general_assets`), but the class names recorded *inside* the SWF still carry
	the original Flash paths - "general_fla.percentage_20", or a bare "waitBox". At runtime
	`AnimateSpriteSymbol.__createObject()` resolves those literally through
	`Type.resolveClass(SymbolUtils.formatClassName(className))`, which adds no package, finds
	nothing, and silently falls back to a plain `openfl.display.MovieClip`.

	The consequence is quiet and wide: the child is created and named correctly, but every
	generated field typed as a *nested symbol class* - `WaitBox.prcMC:Percentage_20`,
	`DungeonMain.diceMC:Dice_4`, `DungeonMap.bridge1:Bridgeanim1_3`, ... - is bound with
	`Reflect.setField`, the plain MovieClip fails the cast to the declared type, and the field
	stays **null**. Fields typed `MovieClip` or `TextField` bind fine, which is why only some
	break.

	Rewriting each symbol's className to the real Haxe class - before anything is instantiated -
	makes `__createObject` build the right class and the typed fields bind.
**/
@:access(swf.exporters.animate)
class SymbolClassBinder {
	/**
		Library id (the string the generated classes pass to `AnimateLibrary.get`) mapped to the
		Haxe packages holding that library's symbol classes. "" means the root package. Order
		matters: the first package that resolves a given short name wins.
	**/
	static var PACKAGES:Map<String, Array<String>> = [
		"f2suLAQTJ2VYvrLpu6D7" => ["general_assets", ""], // general.swf
		"ID11jSMEMP2dDrzhS39l" => ["new_player", "newPlayer_fla", "fl.controls", "fl.controls.listClasses", ""], // newPlayer.swf
		"UdDnTkufe3o6suuTH71R" => ["menu"], // menu.swf
		"dEUCiLnPetwOjMwoCYtE" => ["cards"], // cards.swf
		"keSJYpXT5PuFlPpnJiaM" => ["items"], // items.swf
		"zanu3LQftmwRaVtMQlk3" => ["baby"], // baby.swf
		"BusqAnD3ocfdm6w9UTmT" => ["fight_graphics"], // fightGraphics.swf
		"yGxS0SwgoYsHUrzdr2wX" => ["dungeon_graphics"], // dungeonGraphics.swf
		"40YIf0lE7lVtVgPBVcJt" => ["tower_screens", "tower_screens.fl.containers", "tower_screens.fl.controls", "tower_screens.fl.core", "containers"], // towerScreens.swf
		"nufk0mAnWHAelcPASJ9h" => ["map_graphics"], // mapGraphics.swf
		"Sj0Saz83IZP2ZTQv6YyD" => ["help", "help.fl.controls", "help.fl.core", "fl.controls", "fl.core"], // help.swf
		"jTVIao1d2wKanvG6a3e1" => ["openingAssets_fla", ""], // openingAssets
		"Q36NHA3qwvdz1V1MJewN" => ["dungeon_map"], // dungeon4
		"ZrO6D3S4ajRKUZdukIGY" => ["introBambaAS3_fla"], // IntroBamba.zip
	];

	public static function bind(library:AnimateLibrary):Void {
		if (library == null) return;
		// The registry key the generated classes pass to AnimateLibrary.get() is `uuid`
		// (AnimateLibrary does instances.set(uuid, this)); `id` is just the source file name.
		var key = library.uuid != null ? library.uuid : library.instanceID;
		var packages = PACKAGES.get(key);
		if (packages == null) {
			trace("SymbolClassBinder: no package mapping for library uuid=" + key + " id=" + library.id);
			return;
		}
		var bound = 0;
		var unresolved = [];
		var componentsFrozen = 0;
		for (symbol in library.symbols) {
			if (symbol == null || symbol.className == null) continue;
			if (freezeComponent(symbol)) componentsFrozen++;
			// Already resolvable as-is (the exporter happened to agree with the SWF).
			if (Type.resolveClass(SymbolUtils.formatClassName(symbol.className)) != null) continue;
			var shortName = symbol.className.split(".").pop();
			shortName = shortName.charAt(0).toUpperCase() + shortName.substr(1);
			var resolved = null;
			for (pkg in packages) {
				var candidate = pkg == "" ? shortName : pkg + "." + shortName;
				if (Type.resolveClass(candidate) != null) {
					resolved = candidate;
					break;
				}
			}
			if (resolved != null) {
				symbol.className = resolved;
				bound++;
			} else {
				unresolved.push(symbol.className);
			}
		}
		trace("SymbolClassBinder " + key + ": bound " + bound + ", unresolved " + unresolved.length
			+ (unresolved.length > 0 ? " " + unresolved.slice(0, 5) : "")
			+ (componentsFrozen > 0 ? ", froze " + componentsFrozen + " components" : ""));
	}

	/**
		Flash UI components (fl.controls.CheckBox, fl.containers.ScrollPane, ...) keep their
		live-preview avatar on frame 1 and park every skin on frame 2; their AS3 class stopped the
		timeline on frame 1, so frame 2 was never shown. The generated classes carry no such logic,
		so the clip loops and all the skins flicker on and off every other frame. Dropping
		every frame after the first gives the Flash result.
	**/
	static function freezeComponent(symbol:Dynamic):Bool {
		if (!Std.isOfType(symbol, swf.exporters.animate.AnimateSpriteSymbol)) return false;
		var sprite:swf.exporters.animate.AnimateSpriteSymbol = cast symbol;
		var isComponent = StringTools.startsWith(sprite.className, "fl.")
			|| (sprite.baseClassName != null && StringTools.startsWith(sprite.baseClassName, "fl."));
		if (!isComponent || sprite.frames == null || sprite.frames.length < 2) return false;
		sprite.frames = [sprite.frames[0]];
		return true;
	}
}
