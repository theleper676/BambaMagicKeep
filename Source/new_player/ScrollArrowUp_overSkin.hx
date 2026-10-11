package ;

@:access(swf.exporters.animate)

class ScrollArrowUp_overSkin extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("ID11jSMEMP2dDrzhS39l");
		var symbol = library.symbols.get(40);
		symbol.__init(library);

		super();
	}
}