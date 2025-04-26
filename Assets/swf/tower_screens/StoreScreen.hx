package ;

@:access(swf.exporters.animate)

class StoreScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var storeItemsMC(default, null):StoreItemsMC;
	@:keep @:noCompletion @:dox(hide) public var babyMC(default, null):towerScreens_fla.BabyMC_56;
	@:keep @:noCompletion @:dox(hide) public var basicDataMC(default, null):towerScreens_fla.BasicData_3;
	@:keep @:noCompletion @:dox(hide) public var progressMC(default, null):towerScreens_fla.Bars_5;
	@:keep @:noCompletion @:dox(hide) public var moneyMC(default, null):towerScreens_fla.Money_4;
	@:keep @:noCompletion @:dox(hide) public var itemsMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var itemsSP(default, null):fl.containers.ScrollPane;
	@:keep @:noCompletion @:dox(hide) public var storeItemsSP(default, null):fl.containers.ScrollPane;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):towerScreens_fla.ExitButton_19;
	@:keep @:noCompletion @:dox(hide) public var putOnMC(default, null):towerScreens_fla.Action_btn_arrowed_80;
	@:keep @:noCompletion @:dox(hide) public var sellMC(default, null):towerScreens_fla.Action_btn_arrowed_miror_84;
	@:keep @:noCompletion @:dox(hide) public var buyMC(default, null):towerScreens_fla.Buy_btn_30;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(450);
		symbol.__init(library);

		super();
	}
}