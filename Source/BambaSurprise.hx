package;

import openfl.display.*;

class BambaSurprise  {
	public var sDesc:String;

	public var prizesIds:Array<Float>;

	public var type:Float;

	public var id:Float;

	public var sName:String;

	public function new(data:{type:Int, name:String, id:Int, desc:String, ?prizesids:Dynamic}) {
		this.id = data.id;
		this.sName = data.name;
		this.sDesc = data.desc;
		this.type = data.type;
		// The money-loss (3) and treasure (4) surprises draw a prize from this; left empty, they
		// drew null and crashed in addPrizes.
		this.prizesIds = utils.IdList.parse(data.prizesids);
	/* 	if (Reflect.hasField(data, "prizesIds")) {
			this.prizesIds = data.prizeIds;
		} else {
			prizesIds = [];
		} */
	}
}
