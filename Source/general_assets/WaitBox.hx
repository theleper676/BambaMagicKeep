package general_assets;
@:access(swf.exporters.animate)

class WaitBox extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var dt(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var prcMC(default, null): Percentage_20;
	@:keep @:noCompletion @:dox(hide) public var maskMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var flareMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(105);
		symbol.__init(library);

		super();
	}
}