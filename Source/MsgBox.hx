package ;

@:access(swf.exporters.animate)

class MsgBox extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var dt(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var exitButton(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("jTVIao1d2wKanvG6a3e1");
		var symbol = library.symbols.get(7);
		symbol.__init(library);

		super();
	}
}