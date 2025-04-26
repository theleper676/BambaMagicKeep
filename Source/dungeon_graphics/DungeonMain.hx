package dungeon_graphics;

@:access(swf.exporters.animate)

class DungeonMain extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var mapMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var diceMC(default, null):Dice_4;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):Exit_b_6;
	@:keep @:noCompletion @:dox(hide) public var showMazeMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var rollAgainMC(default, null):RollAgain_10;
	@:keep @:noCompletion @:dox(hide) public var minusOneMC(default, null):MinusOne_13;
	@:keep @:noCompletion @:dox(hide) public var plusOneMC(default, null):PlusOne_15;
	@:keep @:noCompletion @:dox(hide) public var exitSpecialMC(default, null):Special_17;
	@:keep @:noCompletion @:dox(hide) public var showCharacterMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var lowerMC(default, null):LowerMC;

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("yGxS0SwgoYsHUrzdr2wX");
		var symbol = library.symbols.get(313);
		symbol.__init(library);

		super();
	}
}