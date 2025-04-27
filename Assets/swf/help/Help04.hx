package ;

@:access(swf.exporters.animate)

class Help04 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var PIC1(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var PIC2(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var P1(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var P2(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var P5(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var dontShowCB(default, null):fl.controls.CheckBox;
	@:keep @:noCompletion @:dox(hide) public var P3(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var P4(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var L1(default, null):help_fla.Link_15;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("Sj0Saz83IZP2ZTQv6YyD");
		var symbol = library.symbols.get(64);
		symbol.__init(library);

		super();
	}
}