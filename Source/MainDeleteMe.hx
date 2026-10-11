package;

import lime.app.Application;

class Main extends Application
{
	var mainGame: BambaMain;
	public function new()
	{
		super();
		var main = new BambaMain();
		addchild(main);
	}
}
