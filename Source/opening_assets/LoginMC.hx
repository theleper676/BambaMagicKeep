package opening_assets;

@:access(swf.exporters.animate)

class LoginMC extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var userIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var passIT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var errorDT(default, null):openfl.text.TextField;
	@:keep @:noCompletion @:dox(hide) public var forgetPassMC(default, null):Forget_pass_btn_4;
	@:keep @:noCompletion @:dox(hide) public var backMC(default, null):Back_btn_7;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("kpEpsRs04x0FUUF3irW9");
		var symbol = library.symbols.get(33);
		symbol.__init(library);

		super();
	}
}