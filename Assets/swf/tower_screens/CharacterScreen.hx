package ;

@:access(swf.exporters.animate)

class CharacterScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var basicDataMC(default, null):towerScreens_fla.BasicData_3;
	@:keep @:noCompletion @:dox(hide) public var progressMC(default, null):towerScreens_fla.Bars_5;
	@:keep @:noCompletion @:dox(hide) public var moneyMC(default, null):towerScreens_fla.Money_4;
	@:keep @:noCompletion @:dox(hide) public var babyMC(default, null):towerScreens_fla.BabyMC_56;
	@:keep @:noCompletion @:dox(hide) public var itemsMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var itemsSP(default, null):fl.containers.ScrollPane;
	@:keep @:noCompletion @:dox(hide) public var cardsMC(default, null):StoreItemsMC;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):towerScreens_fla.ExitButton_19;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(430);
		symbol.__init(library);

		super();
	}
}