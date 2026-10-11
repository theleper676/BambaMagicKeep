package tower_screens ;

@:access(swf.exporters.animate)

class CharacterScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var basicDataMC(default, null):BasicData_3;
	@:keep @:noCompletion @:dox(hide) public var progressMC(default, null):Bars_5;
	@:keep @:noCompletion @:dox(hide) public var moneyMC(default, null):Money_4;
	@:keep @:noCompletion @:dox(hide) public var babyMC(default, null):BabyMC_56;
	@:keep @:noCompletion @:dox(hide) public var itemsMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var itemsSP(default, null):tower_screens.fl.containers.ScrollPane;
	@:keep @:noCompletion @:dox(hide) public var cardsMC(default, null):StoreItemsMC;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):ExitButton_19;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(430);
		symbol.__init(library);

		super();
	}
}