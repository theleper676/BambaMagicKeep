package towerScreens_fla;

@:access(swf.exporters.animate)

class BasicData_3 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var CHARACTER_NAME(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var CHARACTER_ORDER(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var CHARACTER_LEVEL(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var nameDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var orderDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var levelDT(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(375);
		symbol.__init(library);

		super();
	}
}