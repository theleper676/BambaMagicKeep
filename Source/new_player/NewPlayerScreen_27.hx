package new_player;

import haxe.ui.components.DropDown;

@:access(swf.exporters.animate)

class NewPlayerScreen_27 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null): Backbutton_7;
	@:keep @:noCompletion @:dox(hide) public var enterMC(default, null): Action_btn_29;
	@:keep @:noCompletion @:dox(hide) public var passIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var confirmPassIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var mailIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var userIT(default, null):openfl.text.TextField;
	// These three are NOT SWF symbols. The Flash fl.controls.ComboBox date pickers have no
	// OpenFL equivalent, so the SWF's placeholder clips are replaced at runtime with HaxeUI
	// DropDowns built by BambaNewPlayerScreen.buildDateDropDown(). Writable (not
	// `(default, null)`) so that code can assign them; the symbol binder always leaves them null.
	@:keep @:noCompletion @:dox(hide) public var dayCB:DropDown;
	@:keep @:noCompletion @:dox(hide) public var monthCB:DropDown;
	@:keep @:noCompletion @:dox(hide) public var yearCB:DropDown;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(101);
		symbol.__init(library);

		super();
	}
}