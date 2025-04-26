package ;

@:access(swf.exporters.animate)

class ItemFrame extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var itemMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(406);
		symbol.__init(library);

		super();
	}
}