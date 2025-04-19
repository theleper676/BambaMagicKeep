package ;

@:access(swf.exporters.animate)

class QuestIcon extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("f2suLAQTJ2VYvrLpu6D7");
		var symbol = library.symbols.get(49);
		symbol.__init(library);

		super();
	}
}