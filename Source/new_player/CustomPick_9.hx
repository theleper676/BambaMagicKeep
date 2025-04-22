package new_player;

@:access(swf.exporters.animate)

class CustomPick_9 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var continueMC(default, null): Continuebutton_10;
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):Backbutton_7;
	@:keep @:noCompletion @:dox(hide) public var tab1(default, null):Tab1_12;
	@:keep @:noCompletion @:dox(hide) public var tab2(default, null):Tab2_14;
	@:keep @:noCompletion @:dox(hide) public var tab3(default, null):Tab3_15;
	@:keep @:noCompletion @:dox(hide) public var tab4(default, null):Tab4_16;
	@:keep @:noCompletion @:dox(hide) public var tab5(default, null):Tab5_17;
	@:keep @:noCompletion @:dox(hide) public var tab6(default, null):Tab6_18;
	@:keep @:noCompletion @:dox(hide) public var CH_B_FIRST_LINE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var CH_B_SECOND_LINE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var firstLineMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var secondLineMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var CH_B_CUSTOM_HEAD(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(155);
		symbol.__init(library);

		super();
	}
}