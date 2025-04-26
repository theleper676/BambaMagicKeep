package ;

@:access(swf.exporters.animate)

class CardsUpgradeScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var basicDataMC(default, null):towerScreens_fla.BasicData_3;
	@:keep @:noCompletion @:dox(hide) public var progressMC(default, null):towerScreens_fla.Bars_5;
	@:keep @:noCompletion @:dox(hide) public var moneyMC(default, null):towerScreens_fla.Money_4;
	@:keep @:noCompletion @:dox(hide) public var detailsMC(default, null):towerScreens_fla.UpgradeDetails_35;
	@:keep @:noCompletion @:dox(hide) public var cardsMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):towerScreens_fla.ExitButton_19;
	@:keep @:noCompletion @:dox(hide) public var upgradeMC(default, null):towerScreens_fla.Upgrade_btn_37;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(534);
		symbol.__init(library);

		super();
	}
}