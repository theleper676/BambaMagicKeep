package baby;

@:access(swf.exporters.animate)

class Move1_2 extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var capeMC(default, null):Mc_cape_4;
	@:keep @:noCompletion @:dox(hide) public var stickMC(default, null):Mc_Stik_18;
	@:keep @:noCompletion @:dox(hide) public var shoeRightMC(default, null):Mc_RightShoe_31;
	@:keep @:noCompletion @:dox(hide) public var bodyMC(default, null):Mc_body_43;
	@:keep @:noCompletion @:dox(hide) public var headMC(default, null):Mc_head_46;
	@:keep @:noCompletion @:dox(hide) public var eyesMC(default, null):Mc_eyes_57;
	@:keep @:noCompletion @:dox(hide) public var hatMC(default, null):Mc_Hat_61;
	@:keep @:noCompletion @:dox(hide) public var shoeLeftMC(default, null):Mc_LeftShoe_74;
	@:keep @:noCompletion @:dox(hide) public var beltMC(default, null):Mc_belt_86;
	@:keep @:noCompletion @:dox(hide) public var mc_LowLeftArm(default, null):Mc_LeftLowArm_99;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("zanu3LQftmwRaVtMQlk3");
		var symbol = library.symbols.get(909);
		symbol.__init(library);

		super();
	}
}