package dungeon_graphics;

@:access(swf.exporters.animate)

class Dice_4 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("yGxS0SwgoYsHUrzdr2wX");
		var symbol = library.symbols.get(276);
		symbol.__init(library);

		super();
	}
}