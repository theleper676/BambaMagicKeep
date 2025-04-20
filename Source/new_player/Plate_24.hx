package newPlayer_fla;

@:access(swf.exporters.animate)

class Plate_24 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var nameDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var orderDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var levelDT(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(178);
		symbol.__init(library);

		super();
	}
}