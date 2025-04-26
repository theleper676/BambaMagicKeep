package ;

@:access(swf.exporters.animate)

class DungeonIcon extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var iconMC(default, null):dungeonGraphics_fla.DungeonInerIcon_21;
	@:keep @:noCompletion @:dox(hide) public var specialMC(default, null):dungeonGraphics_fla.Special_17;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("yGxS0SwgoYsHUrzdr2wX");
		var symbol = library.symbols.get(48);
		symbol.__init(library);

		super();
	}
}