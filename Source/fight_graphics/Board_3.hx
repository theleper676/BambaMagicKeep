package fight_graphics;

@:access(swf.exporters.animate)

class Board_3 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("BusqAnD3ocfdm6w9UTmT");
		var symbol = library.symbols.get(41);
		symbol.__init(library);

		super();
	}
}