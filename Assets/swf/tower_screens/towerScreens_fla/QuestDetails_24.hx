package tower_screens;

@:access(swf.exporters.animate)

class QuestDetails_24 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var questDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var moneyDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var xpPointsDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var levelDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var DUNGEON_DIFFICULTY(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var EXPOINTS(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var moneyIconMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var questIconMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var difficultyMC(default, null):towerScreens_fla.Difficulty_27;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(554);
		symbol.__init(library);

		super();
	}
}