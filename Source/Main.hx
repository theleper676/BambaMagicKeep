package;

import openfl.display.Sprite;

class Main extends Sprite
{
	//var main = new BambaMain();
	public function new()
	{
		super();
		
		trace("loading main data");
		var main = new BambaMain();
		trace("done loading main");
		//addChild(main);
	}
}
