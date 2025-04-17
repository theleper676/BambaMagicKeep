package;

import openfl.display.*;

class BambaEnemy {
	public var AIType:Int;

	public var cards:Array<Dynamic>;

	public var eName:String;

	public var assetFileName:String;

	public var prizesIds:Array<Dynamic>;

	public var type:Float;

	public var id:Float;

	public var eDesc:String;

	public var levelCards:Array<Dynamic>;

	public function new(enemy:{type:Int, prizesids:Array<Int>, name:String, levelcards:Array<Array<Int>>, id:Int, desc:String, cards:Null<Array<Int>>, assetfilename:String, aitype:Int}) {
		this.id = enemy.id;
		this.type = enemy.type;
		this.eName = enemy.name;
		this.eDesc = enemy.desc;
		this.assetFileName = enemy.assetfilename;
		this.AIType = enemy.aitype;
		if(Reflect.hasField(enemy, "cards")) {
			this.cards = enemy.cards;
		} else {
			this.cards = [];
		}
		this.prizesIds = enemy.prizesids;
	}
}
