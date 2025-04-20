package new_player;

@:access(swf.exporters.animate)

class NewPlayerScreen_27 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null): Backbutton_7;
	@:keep @:noCompletion @:dox(hide) public var enterMC(default, null): Action_btn_29;
	@:keep @:noCompletion @:dox(hide) public var passIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var confirmPassIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var mailIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var userIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var dayCB(default, null):ComboBox;
	@:keep @:noCompletion @:dox(hide) public var monthCB(default, null):ComboBox;
	@:keep @:noCompletion @:dox(hide) public var yearCB(default, null): ComboBox;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(101);
		symbol.__init(library);

		super();
	}
}