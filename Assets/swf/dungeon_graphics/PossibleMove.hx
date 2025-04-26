package ;

@:access(swf.exporters.animate)

class PossibleMove extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("yGxS0SwgoYsHUrzdr2wX");
		var symbol = library.symbols.get(15);
		symbol.__init(library);

		super();
	}
}