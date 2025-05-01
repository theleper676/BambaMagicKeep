package general_assets;

@:access(swf.exporters.animate)

class MsgBox extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var dt(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var iconMC(default, null): Surpriseicon_15;
	@:keep @:noCompletion @:dox(hide) public var exitButton(default, null):ExitButton_16;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(115);
		symbol.__init(library);

		super();
	}
}