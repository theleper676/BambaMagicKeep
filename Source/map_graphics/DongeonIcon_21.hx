package map_graphics;

@:access(swf.exporters.animate)

class DongeonIcon_21 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var mazeIconMC(default, null): MazeIconMC_22;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("nufk0mAnWHAelcPASJ9h");
		var symbol = library.symbols.get(14);
		symbol.__init(library);

		super();
	}
}