package;

class BambaItemBase {
	public var id:Float;

	public var iType:Int;

	public var buyPrice:Float;

	public var addMagic:Float;

	public var minLevel:Float;

	public var sellPrice:Float;

	public var iDesc:String;

	public var iName:String;

	public var addLife:Float;

	public var addRoundRegeneration:Float;

	public function new(itemBase:{type:Int, sellprice:Int, name:String, minlevel:Int, id:Int, desc:String, buyprice:Int, addroundregeneration:Int, addmagic:Int, addlife:Int}) {
		this.id = itemBase.id;
		this.iName = itemBase.name;
		this.iDesc = itemBase.desc;
		this.iType = itemBase.type;
		this.buyPrice = itemBase.buyprice;
		this.sellPrice = itemBase.sellprice;
		this.minLevel = itemBase.minlevel;
		this.addLife = itemBase.addlife;
		this.addMagic =itemBase.addmagic;
		this.addRoundRegeneration = itemBase.addroundregeneration;
	}
}
