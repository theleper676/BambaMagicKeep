package ;

@:access(swf.exporters.animate)

class DungeonMap extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var lowerMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var bridge1(default, null):dungeon4_fla.Bridgeanim1_3;
	@:keep @:noCompletion @:dox(hide) public var bridge2(default, null):dungeon4_fla.Bridgeanim2_7;
	@:keep @:noCompletion @:dox(hide) public var path1(default, null):dungeon4_fla.Treesanim1_8;
	@:keep @:noCompletion @:dox(hide) public var path2(default, null):dungeon4_fla.Treesanim2_9;
	@:keep @:noCompletion @:dox(hide) public var uperMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("UtXbVqcAJx2ixz4qSRQQ");
		var symbol = library.symbols.get(183);
		symbol.__init(library);

		super();
	}
}