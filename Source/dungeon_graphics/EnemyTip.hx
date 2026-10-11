package dungeon_graphics ;

@:access(swf.exporters.animate)

class EnemyTip extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):PopupBack_25;
	@:keep @:noCompletion @:dox(hide) public var NAME(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var LEVEL(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("yGxS0SwgoYsHUrzdr2wX");
		var symbol = library.symbols.get(25);
		symbol.__init(library);

		super();
	}
}