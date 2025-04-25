package items;

@:access(swf.exporters.animate)

class ItemPopup extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):PopupBack_125;
	@:keep @:noCompletion @:dox(hide) public var DESC(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var LIFE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var MAGIC(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var lifeDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var magicDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var REGENERATION(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var MIN_LEVEL(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var regenerationDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var minLevelDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var PRICE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var priceDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var NAME(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("keSJYpXT5PuFlPpnJiaM");
		var symbol = library.symbols.get(437);
		symbol.__init(library);

		super();
	}
}