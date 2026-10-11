package tower_screens;

@:access(swf.exporters.animate)

class Money_4 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var moneyDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ingredient1DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ingredient2DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ingredient3DT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var ingredient4DT(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(403);
		symbol.__init(library);

		super();
	}
}