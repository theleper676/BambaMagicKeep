package towerScreens_fla;

@:access(swf.exporters.animate)

class BabyMC_56 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var hatMC(default, null):ItemFrame;
	@:keep @:noCompletion @:dox(hide) public var beltMC(default, null):ItemFrame;
	@:keep @:noCompletion @:dox(hide) public var shoesMC(default, null):ItemFrame;
	@:keep @:noCompletion @:dox(hide) public var capeMC(default, null):ItemFrame;
	@:keep @:noCompletion @:dox(hide) public var stickMC(default, null):ItemFrame;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(407);
		symbol.__init(library);

		super();
	}
}