package cards;

@:access(swf.exporters.animate)

class TextMC_6 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var nameDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var descDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var priceDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var minLevelDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var magicDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var damageDT(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("dEUCiLnPetwOjMwoCYtE");
		var symbol = library.symbols.get(133);
		symbol.__init(library);

		super();
	}
}