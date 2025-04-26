package ;

@:access(swf.exporters.animate)

class DungeonMain extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var mapMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var diceMC(default, null):dungeonGraphics_fla.Dice_4;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):dungeonGraphics_fla.Exit_b_6;
	@:keep @:noCompletion @:dox(hide) public var showMazeMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var rollAgainMC(default, null):dungeonGraphics_fla.RollAgain_10;
	@:keep @:noCompletion @:dox(hide) public var minusOneMC(default, null):dungeonGraphics_fla.MinusOne_13;
	@:keep @:noCompletion @:dox(hide) public var plusOneMC(default, null):dungeonGraphics_fla.PlusOne_15;
	@:keep @:noCompletion @:dox(hide) public var exitSpecialMC(default, null):dungeonGraphics_fla.Special_17;
	@:keep @:noCompletion @:dox(hide) public var showCharacterMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("yGxS0SwgoYsHUrzdr2wX");
		var symbol = library.symbols.get(313);
		symbol.__init(library);

		super();
	}
}