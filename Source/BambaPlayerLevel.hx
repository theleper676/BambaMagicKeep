package;

class BambaPlayerLevel {
	public var maxLife:Float;

	public var level:Float;

	public var missionIngredientsIncreasePrc:Float;

	public var missionMoneyIncreasePrc:Float;

	public var fightIngredientsIncreasePrc:Float;

	public var missionExIncreasePrc:Float;

	public var nextLevelEx:Float;

	public var fightMoneyIncreasePrc:Float;

	public var maxMagic:Float;

	public var treasureIngredientsIncreasePrc:Float;

	public var treasureMoneyIncreasePrc:Float;

	public var roundRegeneration:Float;

	public function new(param1:Xml) {

      for (node in param1.elements()) {
		level = Std.parseFloat(node.elementsNamed("level").next()?.firstChild().nodeValue);
        nextLevelEx = Std.parseFloat(node.elementsNamed("nextLevelEx").next()?.firstChild().nodeValue);
		maxLife = Std.parseFloat(node.elementsNamed("maxLife").next()?.firstChild().nodeValue);
		maxMagic = Std.parseFloat(node.elementsNamed("maxMagic").next()?.firstChild().nodeValue);
        roundRegeneration = Std.parseFloat(node.elementsNamed("roundRegeneration").next()?.firstChild().nodeValue);
        missionExIncreasePrc = Std.parseFloat(node.elementsNamed("missionExIncreasePrc").next()?.firstChild().nodeValue);
        missionMoneyIncreasePrc = Std.parseFloat(node.elementsNamed("missionMoneyIncreasePrc").next()?.firstChild().nodeValue);
        missionIngredientsIncreasePrc = Std.parseFloat(node.elementsNamed("missionIngredientsIncreasePrc").next()?.firstChild().nodeValue);
        fightMoneyIncreasePrc = Std.parseFloat(node.elementsNamed("fightMoneyIncreasePrc").next()?.firstChild().nodeValue);
        fightIngredientsIncreasePrc =  Std.parseFloat(node.elementsNamed("fightIngredientsIncreasePrc").next()?.firstChild().nodeValue);
        treasureIngredientsIncreasePrc = Std.parseFloat(node.elementsNamed("treasureIngredientsIncreasePrc").next()?.firstChild().nodeValue);
		};
		//level = param1.level;
		//nextLevelEx = param1.nextLevelEx;
		//maxLife = param1.maxLife;
		//maxMagic = param1.maxMagic;
		//roundRegeneration = param1.roundRegeneration;
		//missionExIncreasePrc = param1.missionExIncreasePrc;
		//missionMoneyIncreasePrc = param1.missionMoneyIncreasePrc;
		//missionIngredientsIncreasePrc = param1.missionIngredientsIncreasePrc;
		//fightMoneyIncreasePrc = param1.fightMoneyIncreasePrc;
		//fightIngredientsIncreasePrc = param1.fightIngredientsIncreasePrc;
		//treasureMoneyIncreasePrc = param1.treasureMoneyIncreasePrc;
		//treasureIngredientsIncreasePrc = param1.treasureIngredientsIncreasePrc;
	}
}
