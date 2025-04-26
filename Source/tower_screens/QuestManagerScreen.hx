package tower_screens;

@:access(swf.exporters.animate)

class QuestManagerScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var basicDataMC(default, null):BasicData_3;
	@:keep @:noCompletion @:dox(hide) public var moneyMC(default, null):Money_4;
	@:keep @:noCompletion @:dox(hide) public var progressMC(default, null):Bars_5;
	@:keep @:noCompletion @:dox(hide) public var crystalBallMC(default, null):Crystalball_13;
	@:keep @:noCompletion @:dox(hide) public var findQuestMC(default, null):Action_btn_14;
	@:keep @:noCompletion @:dox(hide) public var goQuestMC(default, null):Action_btnOK_17;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):ExitButton_19;
	@:keep @:noCompletion @:dox(hide) public var aprovedMC(default, null):Aproved_22;
	@:keep @:noCompletion @:dox(hide) public var questMC(default, null):QuestDetails_24;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(583);
		symbol.__init(library);

		super();
	}
}