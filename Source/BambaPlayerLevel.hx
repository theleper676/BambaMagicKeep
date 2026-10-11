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

	public function new(playerLevel:{treasuremoneyincreaseprc:Int, treasureingredientsincreaseprc:Int, roundregeneration:Int, nextlevelex:Int, missionmoneyincreaseprc:Float, missioningredientsincreaseprc:Int, missionexincreaseprc:Float, maxmagic:Int, maxlife:Int, level:Int, fightmoneyincreaseprc:Int, fightingredientsincreaseprc:Float}) {
		this.level = playerLevel.level;
		this.nextLevelEx = playerLevel.nextlevelex;
		this.maxLife = playerLevel.maxlife;
		this.maxMagic = playerLevel.maxmagic;
		this.roundRegeneration = playerLevel.roundregeneration;
		this.missionExIncreasePrc = playerLevel.missionexincreaseprc;
		this.missionMoneyIncreasePrc = playerLevel.missionmoneyincreaseprc;
		this.fightMoneyIncreasePrc = playerLevel.fightmoneyincreaseprc;
		this.missionIngredientsIncreasePrc = playerLevel.missioningredientsincreaseprc;
		this.fightIngredientsIncreasePrc = playerLevel.fightingredientsincreaseprc;
		this.treasureIngredientsIncreasePrc = playerLevel.treasureingredientsincreaseprc;
	}
}
