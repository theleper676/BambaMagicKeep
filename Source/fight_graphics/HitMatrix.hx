package fight_graphics;

@:access(swf.exporters.animate)

class HitMatrix extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var x0y0(default, null):Mc_fireIndicator01_36;
	@:keep @:noCompletion @:dox(hide) public var x1y0(default, null):Mc_fireIndicator02_37;
	@:keep @:noCompletion @:dox(hide) public var x2y0(default, null):Mc_fireIndicator03_38;
	@:keep @:noCompletion @:dox(hide) public var x3y0(default, null):Mc_fireIndicator04_39;
	@:keep @:noCompletion @:dox(hide) public var x0y1(default, null):Mc_fireIndicator05_40;
	@:keep @:noCompletion @:dox(hide) public var x1y1(default, null):Mc_fireIndicator06_41;
	@:keep @:noCompletion @:dox(hide) public var x2y1(default, null):Mc_fireIndicator07_42;
	@:keep @:noCompletion @:dox(hide) public var x3y1(default, null):Mc_fireIndicator08_43;
	@:keep @:noCompletion @:dox(hide) public var x0y2(default, null):Mc_fireIndicator09_44;
	@:keep @:noCompletion @:dox(hide) public var x1y2(default, null):Mc_fireIndicator10_45;
	@:keep @:noCompletion @:dox(hide) public var x2y2(default, null):Mc_fireIndicator11_46;
	@:keep @:noCompletion @:dox(hide) public var x3y2(default, null):Mc_fireIndicator12_47;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("BusqAnD3ocfdm6w9UTmT");
		var symbol = library.symbols.get(29);
		symbol.__init(library);

		super();
	}
}