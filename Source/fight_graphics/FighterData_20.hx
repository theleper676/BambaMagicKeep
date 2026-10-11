package fight_graphics;

@:access(swf.exporters.animate)

class FighterData_20 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var magicBarMC(default, null):Symbol1_21;
	@:keep @:noCompletion @:dox(hide) public var lifeBarMC(default, null): Bar_27;
	@:keep @:noCompletion @:dox(hide) public var magicDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var lifeDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var LIFE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var MAGIC(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var NAME(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("BusqAnD3ocfdm6w9UTmT");
		var symbol = library.symbols.get(93);
		symbol.__init(library);

		super();
	}
}