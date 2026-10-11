package dungeon_map;

@:access(swf.exporters.animate)

class DungeonMap extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var lowerMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var bridge1(default, null):Bridgeanim1_3;
	@:keep @:noCompletion @:dox(hide) public var bridge2(default, null):Bridgeanim2_7;
	@:keep @:noCompletion @:dox(hide) public var path1(default, null):Treesanim1_8;
	@:keep @:noCompletion @:dox(hide) public var path2(default, null):Treesanim2_9;
	@:keep @:noCompletion @:dox(hide) public var uperMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("Q36NHA3qwvdz1V1MJewN");
		var symbol = library.symbols.get(183);
		symbol.__init(library);

		super();
	}
}