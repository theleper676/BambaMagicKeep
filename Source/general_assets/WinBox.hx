package ;

@:access(swf.exporters.animate)

class WinBox extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var iconMC(default, null):general_fla.Treasurecontainer_27;
	@:keep @:noCompletion @:dox(hide) public var prizesMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var ingredientsMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var dt1(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var headDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var dt2(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var exitButton(default, null):general_fla.ExitButton_16;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(79);
		symbol.__init(library);

		super();
	}
}