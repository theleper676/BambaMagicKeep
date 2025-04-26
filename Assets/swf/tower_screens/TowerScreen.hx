package ;

@:access(swf.exporters.animate)

class TowerScreen extends #if flash flash.display.MovieClip.MovieClip2 #else openfl.display.MovieClip #end
{
	@:keep @:noCompletion @:dox(hide) public var towerBackMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var exitMC(default, null):towerScreens_fla.ExitB_41;
	@:keep @:noCompletion @:dox(hide) public var upgradeMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var storeMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var columnsMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var magicMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var questMC(default, null):towerScreens_fla.CrystalBall_48;
	@:keep @:noCompletion @:dox(hide) public var moveRightMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var moveLeftMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var characterMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var leftArrowMC(default, null):openfl.display.MovieClip;
	@:keep @:noCompletion @:dox(hide) public var rightArrowMC(default, null):openfl.display.MovieClip;
	

	public function new()
	{
		var library = swf.exporters.animate.AnimateLibrary.get("40YIf0lE7lVtVgPBVcJt");
		var symbol = library.symbols.get(511);
		symbol.__init(library);

		super();
	}
}