package ;

@:access(swf.exporters.animate)

class GeneralFrame extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var holesMC(default, null):general_fla.Holes_2;
	@:keep @:noCompletion @:dox(hide) public var helpMC(default, null):general_fla.HelpMC_7;
	@:keep @:noCompletion @:dox(hide) public var musicVolumeMC(default, null):general_fla.VolumeBar_8;
	@:keep @:noCompletion @:dox(hide) public var effectsVolumeMC(default, null):general_fla.VolumeBar_8;
	@:keep @:noCompletion @:dox(hide) public var mainMenuMC(default, null):general_fla.FullScreen_13;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(178);
		symbol.__init(library);

		super();
	}
}