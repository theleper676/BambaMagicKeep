package opening_assets;

@:access(swf.exporters.animate)

class LoadingBarMC extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var loaderDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var msgDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var maskMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var flareMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("kpEpsRs04x0FUUF3irW9");
		var symbol = library.symbols.get(49);
		symbol.__init(library);

		super();
	}
}