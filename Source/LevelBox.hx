package;

@:access(swf.exporters.animate)

class LevelBox extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var LIFE(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var MAGIC(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var REGENERATION(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var lifeDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var magicDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var regenerationDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var levelDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var exitButton(default, null):Button_small_35;
	@:keep @:noCompletion @:dox(hide) public var dt(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var headDT(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(40);
		symbol.__init(library);

		super();
	}
}