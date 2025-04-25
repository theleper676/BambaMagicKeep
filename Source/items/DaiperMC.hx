package items;

@:access(swf.exporters.animate)

class DaiperMC extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("keSJYpXT5PuFlPpnJiaM");
		var symbol = library.symbols.get(317);
		symbol.__init(library);

		super();
	}
}