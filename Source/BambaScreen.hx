package ;
import openfl.display.MovieClip;
import openfl.display.DisplayObject;
import general.ButtonUpdater;

class BambaScreen extends DisplayObject {
    public var game:BambaMain;
    public var mc:Dynamic;
    public function new(mainGame:BambaMain) {
        super();
        game = mainGame;
    }

    public function update():Void {
     
    }

    public function cardRollOver (id:Float): Void {

    }

    public function cardClicked(param1:Dynamic):Void {
	}

    public function setupButton(button:MovieClip, callback:Dynamic):Void {
        ButtonUpdater.setButton(button, callback);
    }
}