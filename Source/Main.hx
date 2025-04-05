/* package;

import openfl.display.*;
import openfl.utils.Assets;
import swf.exporters.animate.AnimateLibrary;
import openfl.display.Sprite;

class Main extends Sprite
{
	//var main = new BambaMain();
	public function new()
	{
		super();
		if (this.stage != null) {
			init();
		}
	}

	private function fitToStage (main:BambaMain) {
		var originalWidth:Float = main.width / main.scaleX;
		var originalHeight:Float = main.height / main.scaleY;

		var scaleX:Float = stage.stageWidth / originalWidth;
        var scaleY:Float = stage.stageHeight / originalHeight;
        var scaleFactor:Float = Math.max(scaleX, scaleY);

		main.scaleX = main.scaleY = scaleFactor;

		main.x = (stage.stageWidth - main.width) / 2;
		main.y = (stage.stageHeight - main.height) / 2;
	}
	private function init (): Void {
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.color = 0x000000;
		var main = new BambaMain();
		this.addChild(main);

		//haxe.Timer.delay(() -> fitToStage(main), 6000);
	}
}
 */