package general_assets;

@:access(swf.exporters.animate)

class QuestBox extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var headDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var EXPOINTS(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var exPointsDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var prizeMC(default, null):PrizeIconcopy_30;
	@:keep @:noCompletion @:dox(hide) public var questIconMC(default, null):QuestIcon;
	@:keep @:noCompletion @:dox(hide) public var exitButton(default, null):Button_small_35;
	@:keep @:noCompletion @:dox(hide) public var dt(default, null):openfl.text.TextField;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(63);
		symbol.__init(library);

		super();
	}
}