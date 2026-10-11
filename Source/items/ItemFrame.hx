package items;

@:access(swf.exporters.animate)

class ItemFrame extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null): Itemtile_120;
	@:keep @:noCompletion @:dox(hide) public var itemMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("keSJYpXT5PuFlPpnJiaM");
		var symbol = library.symbols.get(448);
		symbol.__init(library);

		super();
	}
}