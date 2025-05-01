package ;

@:access(swf.exporters.animate)

class OpeningScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var loginMC(default, null):LoginMC;
	@:keep @:noCompletion @:dox(hide) public var loadingBarMC(default, null):LoadingBarMC;
	@:keep @:noCompletion @:dox(hide) public var enterMC(default, null):openingAssets_fla.Ok_btn_13;
	@:keep @:noCompletion @:dox(hide) public var forgetPassWinMC(default, null):ForgetPassWinMC;
	@:keep @:noCompletion @:dox(hide) public var newMC(default, null):openingAssets_fla.Newuser_btn_20;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("uOEBAPPOKEcvSyhH7DIX");
		var symbol = library.symbols.get(71);
		symbol.__init(library);

		super();
	}
}