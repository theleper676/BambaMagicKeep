package newPlayer_fla;

@:access(swf.exporters.animate)

class OrderMC_21 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var orderFrameMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var iconMC(default, null):newPlayer_fla.IconMC_23;
	@:keep @:noCompletion @:dox(hide) public var ORDER_NAME(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ORDER_DESC(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(171);
		symbol.__init(library);

		super();
	}
}