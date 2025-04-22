package new_player;

@:access(swf.exporters.animate)

class OrderPick_20 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var CH_B_TITLE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var CH_B_TEXT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var order1(default, null):OrderMC_21;
	@:keep @:noCompletion @:dox(hide) public var order2(default, null):OrderMC_21;
	@:keep @:noCompletion @:dox(hide) public var order3(default, null):OrderMC_21;
	@:keep @:noCompletion @:dox(hide) public var continueMC(default, null):Continuebutton_10;
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):Backbutton_7;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(172);
		symbol.__init(library);

		super();
	}
}