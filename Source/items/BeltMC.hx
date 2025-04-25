package items;

@:access(swf.exporters.animate)

class BeltMC extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("keSJYpXT5PuFlPpnJiaM");
		var symbol = library.symbols.get(418);
		symbol.__init(library);

		super();
	}
}