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

	public function new() {
		var json = JsonParser.load("Assets/json/playerLevels.json");
		if(json != null && json.playerlevels != null) {
			var playerLevels = json.playerlevels[0];
			level = playerLevels.level;
				nextLevelEx = playerLevels.nextlevelex;
				maxLife = playerLevels.maxlife;
				maxMagic = playerLevels.maxmagic;
				roundRegeneration = playerLevels.roundregeneration;
				missionExIncreasePrc = playerLevels.missionexincreaseprc;
				missionMoneyIncreasePrc = playerLevels.missionmoneyincreaseprc;
				missionIngredientsIncreasePrc = playerLevels.missioningredientsincreaseprc;
				fightMoneyIncreasePrc = playerLevels.fightmoneyincreaseprc;
				fightIngredientsIncreasePrc = playerLevels.fightingredientsincreaseprc;
				treasureIngredientsIncreasePrc = playerLevels.treasureingredientsincreaseprc;
		}
	}
}
