package general_fla;

@:access(swf.exporters.animate)

class VolumeBar_8 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var maskMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var sliderMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(171);
		symbol.__init(library);

		super();
	}
}