package;

import openfl.events.EventDispatcher;
import openfl.display.DisplayObject;

class BambaDungeonTile  {
	public var links:Array<Dynamic>;

	public var level:Float;

	public var jump:Float;

	public var x:Float;

	public var y:Float;

	public var id:Float;

    public function new (id: Float, x: Float,y: Float, links: String, jump:Float){
		this.id = id;
		this.x = x;
		this.y = y;
		this.links = links.split(",");
		this.jump = jump;
		level = 1;
    }

}
