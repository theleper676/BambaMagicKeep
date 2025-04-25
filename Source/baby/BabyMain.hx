package baby;

@:access(swf.exporters.animate)

class BabyMain extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var movesMC(default, null):Move1_2;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("zanu3LQftmwRaVtMQlk3");
		var symbol = library.symbols.get(910);
		symbol.__init(library);

		super();
	}
}