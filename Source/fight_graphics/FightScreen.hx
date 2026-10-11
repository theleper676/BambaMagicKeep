package fight_graphics;

@:access(swf.exporters.animate)

class FightScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var boardMC(default, null):Board_3;
	@:keep @:noCompletion @:dox(hide) public var continueButtonParent(default, null): ContinueButton_5;
	@:keep @:noCompletion @:dox(hide) public var cardsFightMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var cardPickMC(default, null): CardPick_10;
	@:keep @:noCompletion @:dox(hide) public var meData(default, null): FighterData_20;
	@:keep @:noCompletion @:dox(hide) public var enemyData(default, null):FighterData_29;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("BusqAnD3ocfdm6w9UTmT");
		var symbol = library.symbols.get(104);
		symbol.__init(library);

		super();
	}
}