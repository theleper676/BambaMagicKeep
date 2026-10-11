package dungeon_map;

@:access(swf.exporters.animate)

class FightBack extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("Q36NHA3qwvdz1V1MJewN");
		var symbol = library.symbols.get(21);
		symbol.__init(library);

		super();
	}
}