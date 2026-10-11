package help;


@:access(swf.exporters.animate)

class EmptyCard extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("Sj0Saz83IZP2ZTQv6YyD");
		var symbol = library.symbols.get(3);
		symbol.__init(library);

		super();
	}
}