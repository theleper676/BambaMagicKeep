package menu;

@:access(swf.exporters.animate)

class MenuScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var plateMC(default, null):Plate_3;
	@:keep @:noCompletion @:dox(hide) public var babyMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var menuMC(default, null):MenuMC_5;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("UdDnTkufe3o6suuTH71R");
		var symbol = library.symbols.get(33);
		symbol.__init(library);

		super();
	}
}