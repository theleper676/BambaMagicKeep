package fight_graphics;

@:access(swf.exporters.animate)

class HitPoints extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var dtMC(default, null): DtMC_49;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("BusqAnD3ocfdm6w9UTmT");
		var symbol = library.symbols.get(4);
		symbol.__init(library);

		super();
	}
}