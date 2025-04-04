package;

import openfl.utils.Assets;
import swf.exporters.animate.AnimateLibrary;
import openfl.display.Sprite;

class Main extends Sprite
{
	//var main = new BambaMain();
	public function new()
	{
		super();
		var main = new BambaMain();
		this.addChild(main);
		//addChild(main);
	}
}
