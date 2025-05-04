package;

import openfl.utils.Assets;
import swf.exporters.animate.AnimateLibrary;
import openfl.display.Sprite;

class Main extends Sprite
{
	var main = new BambaMain();
	public function new()
	{
		super();
		if (this.stage != null) {
			init();
		}
	}

	private function init (): Void {
        trace("init preloader");
		var libraryPath = Assets.getPath("openingAssets");
		AnimateLibrary.loadFromFile(libraryPath).onComplete((_)-> {
            addChild(main);
            trace("done initing preloader");
        });
	}
}
