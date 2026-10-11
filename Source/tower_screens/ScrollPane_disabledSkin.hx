package tower_screens;

@:access(swf.exporters.animate)

class ScrollPane_disabledSkin extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(8);
		symbol.__init(library);

		super();
	}
}