package cards_fla;

@:access(swf.exporters.animate)

class Card_13 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var picMC(default, null):cards_fla.Symbol1_3;
	@:keep @:noCompletion @:dox(hide) public var shapeMC(default, null):cards_fla.ShapeMC_4;
	@:keep @:noCompletion @:dox(hide) public var upgradeMC(default, null):cards_fla.Upgrades_14;
	@:keep @:noCompletion @:dox(hide) public var nameDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var damageDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var costDT(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("dEUCiLnPetwOjMwoCYtE");
		var symbol = library.symbols.get(108);
		symbol.__init(library);

		super();
	}
}