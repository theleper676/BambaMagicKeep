package ;

@:access(swf.exporters.animate)

class QuestManagerScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var basicDataMC(default, null):towerScreens_fla.BasicData_3;
	@:keep @:noCompletion @:dox(hide) public var moneyMC(default, null):towerScreens_fla.Money_4;
	@:keep @:noCompletion @:dox(hide) public var progressMC(default, null):towerScreens_fla.Bars_5;
	@:keep @:noCompletion @:dox(hide) public var crystalBallMC(default, null):towerScreens_fla.Crystalball_13;
	@:keep @:noCompletion @:dox(hide) public var findQuestMC(default, null):towerScreens_fla.Action_btn_14;
	@:keep @:noCompletion @:dox(hide) public var goQuestMC(default, null):towerScreens_fla.Action_btnOK_17;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):towerScreens_fla.ExitButton_19;
	@:keep @:noCompletion @:dox(hide) public var aprovedMC(default, null):towerScreens_fla.Aproved_22;
	@:keep @:noCompletion @:dox(hide) public var questMC(default, null):towerScreens_fla.QuestDetails_24;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(583);
		symbol.__init(library);

		super();
	}
}