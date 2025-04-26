package towerScreens_fla;

@:access(swf.exporters.animate)

class Bars_5 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var LIFE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var MAGIC(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var lifeDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var magicDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var exPointsDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var REGENERATION(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var regenerationDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var xpBarMC(default, null):towerScreens_fla.Bar_6;
	@:keep @:noCompletion @:dox(hide) public var exPointsNextDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var NEXT_LEVEL(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var EXPOINTS(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(397);
		symbol.__init(library);

		super();
	}
}