package new_player;

import openfl.display.MovieClip;

@:access(swf.exporters.animate)

class CharacterBuildScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var nameMC(default, null): MovieClip;
	@:keep @:noCompletion @:dox(hide) public var customMC(default, null):CustomPick_9;
	@:keep @:noCompletion @:dox(hide) public var orderMC(default, null):OrderPick_20;
	@:keep @:noCompletion @:dox(hide) public var plateMC(default, null):Plate_24;
	@:keep @:noCompletion @:dox(hide) public var babyMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(180);
		symbol.__init(library);

		super();
	}
}