package general_assets ;

@:access(swf.exporters.animate)

class PrizeIcon extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var iconMC(default, null):PrizePic_31;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(20);
		symbol.__init(library);

		super();
	}
}