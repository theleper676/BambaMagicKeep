package;

import openfl.display.*;

class BambaSurprise  {
	public var sDesc:String;

	public var prizesIds:Array<Dynamic>;

	public var type:Float;

	public var id:Float;

	public var sName:String;

	public function new(data:{type:Int, name:String, id:Int, desc:String}) {
		this.id = data.id;
		this.sName = data.name;
		this.sDesc = data.desc;
		this.type = data.type;
		this.prizesIds = [];
	/* 	if (Reflect.hasField(data, "prizesIds")) {
			this.prizesIds = data.prizeIds;
		} else {
			prizesIds = [];
		} */
	}
}
