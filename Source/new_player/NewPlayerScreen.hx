package new_player;

@:access(swf.exporters.animate)

class NewPlayerScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var screenMC(default, null): NewPlayerScreen_27;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(102);
		symbol.__init(library);

		super();
	}
}