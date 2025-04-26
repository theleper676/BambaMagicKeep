package tower_screens;

@:access(swf.exporters.animate)

class UpgradeDetails_35 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var ingredient1DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ingredient2DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ingredient3DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var minLevelDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var nameDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var descDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ingredient4DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var newCardMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(528);
		symbol.__init(library);

		super();
	}
}