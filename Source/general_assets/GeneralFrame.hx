package general_assets ;

@:access(swf.exporters.animate)

class GeneralFrame extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var holesMC(default, null):Holes_2;
	@:keep @:noCompletion @:dox(hide) public var helpMC(default, null):HelpMC_7;
	@:keep @:noCompletion @:dox(hide) public var musicVolumeMC(default, null): VolumeBar_8;
	@:keep @:noCompletion @:dox(hide) public var effectsVolumeMC(default, null):VolumeBar_8;
	@:keep @:noCompletion @:dox(hide) public var mainMenuMC(default, null):FullScreen_13;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(178);
		symbol.__init(library);

		super();
	}
}