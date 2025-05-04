package;

@:access(swf.exporters.animate)

class YesNoBox extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var dt(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var confirmButton(default, null): ExitButton_16;
	@:keep @:noCompletion @:dox(hide) public var cancelButton(default, null): CancelButton_24;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(85);
		symbol.__init(library);

		super();
	}
}