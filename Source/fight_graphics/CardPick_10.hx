package fight_graphics;

@:access(swf.exporters.animate)

class CardPick_10 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var smallBoardMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var fightButton(default, null): FightButton_16;
	@:keep @:noCompletion @:dox(hide) public var cardsPickBoardMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var cardsPickedMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("BusqAnD3ocfdm6w9UTmT");
		var symbol = library.symbols.get(69);
		symbol.__init(library);

		super();
	}
}