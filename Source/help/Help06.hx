package help;
import haxe.ui.components.CheckBox;
@:access(swf.exporters.animate)

class Help06 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var dontShowCB(default, null): CheckBox;
	@:keep @:noCompletion @:dox(hide) public var P1(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var P5(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var L1(default, null):Link_15;
	@:keep @:noCompletion @:dox(hide) public var L2(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L3(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L4(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L5(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L6(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L7(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L8(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L9(default, null):Link2_21;
	@:keep @:noCompletion @:dox(hide) public var L10(default, null):Link2_21;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("Sj0Saz83IZP2ZTQv6YyD");
		var symbol = library.symbols.get(48);
		symbol.__init(library);

		super();
	}
}