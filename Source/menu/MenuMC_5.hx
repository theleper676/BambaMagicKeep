package menu;

@:access(swf.exporters.animate)

class MenuMC_5 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var videoMC(default, null):Action_btn2_6;
	@:keep @:noCompletion @:dox(hide) public var startMC(default, null):Action_btn_9;
	@:keep @:noCompletion @:dox(hide) public var newCharacterMC(default, null):Action_btn3_11;
	@:keep @:noCompletion @:dox(hide) public var helpMC(default, null):Action_btn4_13;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):Action_btn5_15;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("UdDnTkufe3o6suuTH71R");
		var symbol = library.symbols.get(32);
		symbol.__init(library);

		super();
	}
}