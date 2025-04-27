package ;

@:access(swf.exporters.animate)

class KingdomMap extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var area1MC(default, null):mapGraphics_fla.Blind_map_castel_7;
	@:keep @:noCompletion @:dox(hide) public var area3MC(default, null):mapGraphics_fla.Blind_map_mountain_8;
	@:keep @:noCompletion @:dox(hide) public var area6MC(default, null):mapGraphics_fla.Blind_map_swamp_9;
	@:keep @:noCompletion @:dox(hide) public var area2MC(default, null):mapGraphics_fla.Blind_map_forest_10;
	@:keep @:noCompletion @:dox(hide) public var area4MC(default, null):mapGraphics_fla.Blind_map_lake_11;
	@:keep @:noCompletion @:dox(hide) public var area5MC(default, null):mapGraphics_fla.Blind_map_desert_12;
	@:keep @:noCompletion @:dox(hide) public var iconsMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var mapAnimMC(default, null):mapGraphics_fla.MapAmin_14;
	@:keep @:noCompletion @:dox(hide) public var towerMC(default, null):mapGraphics_fla.Tower_16;
	@:keep @:noCompletion @:dox(hide) public var showCharacterMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("nufk0mAnWHAelcPASJ9h");
		var symbol = library.symbols.get(63);
		symbol.__init(library);

		super();
	}
}