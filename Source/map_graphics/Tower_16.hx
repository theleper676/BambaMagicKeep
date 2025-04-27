package map_graphics;

@:access(swf.exporters.animate)

class Tower_16 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var specialMC(default, null):  Special_17;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("nufk0mAnWHAelcPASJ9h");
		var symbol = library.symbols.get(59);
		symbol.__init(library);

		super();
	}
}