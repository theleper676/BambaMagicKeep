package containers;

@:access(swf.exporters.animate)

class ScrollPane2 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(32);
		symbol.__init(library);

		super();
	}
}