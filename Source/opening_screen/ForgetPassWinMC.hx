package opening_screen;

@:access(swf.exporters.animate)

class ForgetPassWinMC extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var mailIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var sendMailMC(default, null): Sendt_pass_btn_17;
	@:keep @:noCompletion @:dox(hide) public var errorDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null): Back_btn_7;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("jTVIao1d2wKanvG6a3e1");
		var symbol = library.symbols.get(65);
		symbol.__init(library);

		super();
	}
}