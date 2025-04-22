package ;

@:access(swf.exporters.animate)

class CardBase extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var frontMC(default, null):cards_fla.Card_13;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("dEUCiLnPetwOjMwoCYtE");
		var symbol = library.symbols.get(112);
		symbol.__init(library);

		super();
	}
}