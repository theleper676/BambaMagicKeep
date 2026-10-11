package;

import openfl.events.EventDispatcher;
import openfl.display.DisplayObject;

class BambaDungeonTile  {
	// Tile ids, as numbers: the data has them as a "3,7" string, and AS3 let "7" == 7 pass.
	// Haxe does not, so string links made getTile() miss and the dungeon code null out.
	public var links:Array<Float>;

	public var level:Float;

	public var jump:Float;

	public var x:Float;

	public var y:Float;

	public var id:Float;

    public function new (id: Float, x: Float,y: Float, links: String, jump:Float){
		this.id = id;
		this.x = x;
		this.y = y;
		this.links = [for (link in links.split(",")) if (StringTools.trim(link) != "") Std.parseFloat(link)];
		this.jump = jump;
		this.level = 1;
    }

}
