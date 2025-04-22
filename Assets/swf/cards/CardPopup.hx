package ;

@:access(swf.exporters.animate)

class CardPopup extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):cards_fla.PopupBack_11;
	@:keep @:noCompletion @:dox(hide) public var NAME(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var DESC(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("dEUCiLnPetwOjMwoCYtE");
		var symbol = library.symbols.get(119);
		symbol.__init(library);

		super();
	}
}