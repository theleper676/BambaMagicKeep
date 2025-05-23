package map_graphics;

@:access(swf.exporters.animate)

class MapIcon extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var iconMC(default, null):DongeonIcon_21;
	@:keep @:noCompletion @:dox(hide) public var specialMC(default, null):Special_17;
	public var dongeonId:Float;

	public function new()
	{
		this.dongeonId = 0;
		var library = swf.exporters.animate.AnimateLibrary.get("nufk0mAnWHAelcPASJ9h");
		var symbol = library.symbols.get(20);
		symbol.__init(library);

		super();
	}
}