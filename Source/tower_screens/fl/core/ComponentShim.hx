package tower_screens.fl.core;

@:access(swf.exporters.animate)

class ComponentShim extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(3);
		symbol.__init(library);

		super();
	}
}