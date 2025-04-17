package;

import motion.easing.Quad;
import openfl.utils.QName;

typedef Quest = {
	var id:Int;
	var name:Dynamic; // Mostly String, but sometimes Int
	var desc:String;
	var type:Int;
	var dungeonids:Array<Int>;
	var dungeondifficulties:Array<Int>;
	var enemiesids:Array<Int>;
	var prizesids:Array<Int>;
	var expoints:Int;
	var minlevel:Int;
	var qgraphics:Int;
	var endmsg:String;
	@:optional var tutorialcode:Int;
	@:optional var text:String;
  }

class BambaQuest  {
	public var tutorialCode:Float;

	public var minLevel:Float;

	public var questsPossibleDungeonsIds:Array<Dynamic>;

	public var prizesIds:Array<Dynamic>;

	public var id:Float;

	public var qGraphics:Float;

	public var dungeonIds:Array<Dynamic>;

	public var qDesc:String;

	public var qName:String;

	public var endMsg:String;

	public var enemiesIds:Array<Dynamic>;

	public var dungeonDifficulties:Array<Dynamic>;

	public var type:Int;

	public var exPoints:Float;

	public function new(questData:Quest) {
		this.id = questData.id;
		this.qName = questData.name;
		this.qDesc = questData.desc;
		this.type = questData.type;
		this.dungeonIds = questData.dungeonids;
		this.dungeonDifficulties = questData.dungeondifficulties;
		this.prizesIds = questData.prizesids;
		this.exPoints = questData.expoints;
		this.minLevel = questData.minlevel;
		this.qGraphics = questData.qgraphics;
		this.endMsg = questData.endmsg;
		this.tutorialCode = questData.tutorialcode;
		this.questsPossibleDungeonsIds = [];
		if(questData.enemiesids.length > 0) {
			this.enemiesIds = questData.enemiesids;
		} else {
			this.enemiesIds = [];
		}
		/* id = Std.parseFloat(param1.get("id"));
		//qName = param1.get("name");
		//qDesc = param1.get("desc");
		//type = Std.parseInt(param1.get("type"));
		//dungeonIds = param1.get("dungeonIds").split(",");
		//dungeonDifficulties = param1.get("dungeonDifficulties").split(",");
	
		//if (param1.get("enemiesIds") != "") {
			enemiesIds = param1.get("enemiesIds").split(",");
		} else {
			enemiesIds = [];
		}
		//prizesIds = param1.get("prizesIds").split(",");
		//exPoints = Std.parseFloat(param1.get("exPoints"));
		//minLevel = Std.parseFloat(param1.get("menLevel"));
		//qGraphics =  Std.parseFloat(param1.get("qGraphics"));
		//endMsg = param1.get("endMsg");
		//tutorialCode = Std.parseFloat(param1.get("tutorialCode"));
		questsPossibleDungeonsIds = []; */
	}
}
