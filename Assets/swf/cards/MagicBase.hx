package ;

@:access(swf.exporters.animate)

class MagicBase extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var picMC(default, null):cards_fla.Symbol1_3;
	@:keep @:noCompletion @:dox(hide) public var shapeMC(default, null):cards_fla.ShapeMC_4;
	@:keep @:noCompletion @:dox(hide) public var textMC(default, null):cards_fla.TextMC_6;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("dEUCiLnPetwOjMwoCYtE");
		var symbol = library.symbols.get(142);
		symbol.__init(library);

		super();
	}
}