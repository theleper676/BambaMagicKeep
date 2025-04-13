package;

class BambaPlayerLevel {
	public var maxLife:Int;

	public var level:Int;

	public var missionIngredientsIncreasePrc:Int;

	public var missionMoneyIncreasePrc:Float;

	public var fightIngredientsIncreasePrc:Float;

	public var missionExIncreasePrc:Float;

	public var nextLevelEx:Int;

	public var fightMoneyIncreasePrc:Int;

	public var maxMagic:Int;

	public var treasureIngredientsIncreasePrc:Int;

	public var treasureMoneyIncreasePrc:Int;

	public var roundRegeneration:Int;

	public function new(treasuremoneyincreaseprc:Int, treasureingredientsincreaseprc:Int, roundregeneration:Int, nextlevelex:Int, missionmoneyincreaseprc:Float, missioningredientsincreaseprc:Int, missionexincreaseprc:Float, maxmagic:Int, maxlife:Int, level:Int, fightmoneyincreaseprc:Int, fightingredientsincreaseprc:Float) {
		this.level = level;
		this.nextLevelEx = nextlevelex;
		this.maxLife = maxlife;
		this.maxMagic = maxmagic;
		this.roundRegeneration = roundregeneration;
		this.missionExIncreasePrc = missionexincreaseprc;
		this.missionMoneyIncreasePrc = missionmoneyincreaseprc;
		this.fightMoneyIncreasePrc = fightmoneyincreaseprc;
		this.missionIngredientsIncreasePrc = missioningredientsincreaseprc;
		this.fightIngredientsIncreasePrc = fightingredientsincreaseprc;
		this.treasureIngredientsIncreasePrc = treasureingredientsincreaseprc;
	}
}
