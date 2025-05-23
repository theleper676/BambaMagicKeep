package;

class BambaData {
	public var questsCatalog:Array<BambaQuest>;

	public var enemiesCatalog:Array<BambaEnemy>;

	public var surprisesCatalog:Array<BambaSurprise>;

	public var beenHitAnimName:String;

	public var enemiesLevelsCatalog:Array<BambaEnemyLevel>;

	public var mapData:BambaMapData;
	//TODO: public var mapData:BambaMapData;

	public var itemsBaseCatalog:Array<BambaItemBase>;

	public var playerData:BambaPlayerData;

	public var characterCustomDefs:Array<Dynamic>;

	public var ordersStartDefs:Array<Dynamic>;

	public var cardsCatalog:Array<BambaCard>;

	public var fightBoardXY:Array<Array<Array<String>>>;

	public var prizesCatalog:Array<BambaPrize>;

	public var itemsCatalog:Array<Dynamic>;

	public var winAnimName:String;

	public var playerLevelsCatalog:Array<BambaPlayerLevel>;

	public var mapTimes:Map<String,Float>;

	public var fightZsize:Array<Float>;

	public var itemsLevels:Array<Int>;

	public var minLevel:Float;

	public var winAnimLength:Float;

	public var dungeonsDataCatalog:Array<BambaDungeonData>;

	public var maxEnemyLevel:Float;

	public var loseAnimName:String;

	public var dungeonDifficulties:Array<Dynamic>;

	public var defaultAnimLength:Float;

	public var defaultDungeonAnimLength:Float;

	public var maxLevel:Float;

	public var fightSmallBoardXY:Array<Array<Array<String>>>;

	public var dictionary:BambaDictionary;

	public var helpCatalog:Array<BambaHelpPage>;

	public var mapTrails:Array<String>;

	public var magicCatalog:Array<BambaMagic>;

	public var storeItemsCatalog:Array<Dynamic>;

	public var enemyId:Float;

	public var barAnimLength:Float;

	public var minEnemyLevel:Float;

	public var fightXoffset:Array<Int>;

	public var enemyType:Float;

	public var sharedOrder:Float;

	public var game:BambaMain;

	public var mapTimeDef:Float;

	public function new(mainGame:BambaMain) {
		game = mainGame;
		dictionary = new BambaDictionary();
		playerData = new BambaPlayerData(game);
		playerLevelsCatalog = [];
		magicCatalog = [];
		cardsCatalog = [];
		enemiesCatalog = [];
		enemiesLevelsCatalog = [];
		itemsBaseCatalog = [];
		itemsCatalog = [];
		storeItemsCatalog = [];
		prizesCatalog = [];
		surprisesCatalog = [];
		dungeonsDataCatalog = [];
		questsCatalog = [];
		helpCatalog = [];
	}

	// Return type should be BambaSurprise
	public function getCatalogSurprise(param1:Dynamic):BambaSurprise {
		var _loc2_:Null<Dynamic> = null;
		_loc2_ = 0;
		while (_loc2_ < surprisesCatalog.length) {
			if (surprisesCatalog[_loc2_].id == param1) {
				return surprisesCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null;
	}

	function buildDungeonsDataCatalog():Void {
		trace("building dungeon data catalog");
		var dungeonsData = JsonParser.load("Assets/json/dungeonsData.json");
		for (data in dungeonsData.dungeonsDatas) {
			var _dungeonData = new BambaDungeonData(data);
			_dungeonData.setMinLevel(mapData.areas);
		}
		/* var _loc2_:Xml = null;
		var _loc3_:BambaDungeonData = null;
		for (_loc2_ in param1) {
			_loc3_ = new BambaDungeonData(_loc2_);
			_loc3_.setMinLevel(mapData.areas);
			dungeonsDataCatalog.push(_loc3_);
		} */
	}

	public function loadDictionary(dictionaryXml:Xml):Void {
		dictionary.load(dictionaryXml);
	}

	//TODO: RETURN TYPE SHOULD BE BambaEnemyLevel
	public function getCatalogEnemyLevel(level:Int, type:Int):BambaEnemyLevel {
		for (enemyLevel in enemiesLevelsCatalog) {
			if(enemyLevel.level == level && enemyLevel.type == type) {
				return enemyLevel;
			}
		}
		return null;
	}

	function buildEnemiesCatalog():Void {
		trace("building enemies Catalog");
		var enemiesJson = JsonParser.load("Assets/json/enemies.json");
		for (enemy in enemiesJson.enemies) {
			var _enemy = new BambaEnemy(enemy);
			enemiesCatalog.push(_enemy);
		}
	}

	// TODO:FIX!
	public function loadCharacterCustom(tab:Array<{line2dep:Int, line2:Array<Int>, line1:Array<Int>}>):Void {
		/* for (entry in tab) {
			var _list:Array<Dynamic> = [entry.line1];

			if(entry.line2dep == 0) {
				_list.push(entry.line2);
			}
		} */
		/* var _loc2_:Null<Dynamic> = null;
		var _loc3_:Null<Dynamic> = null;
		var _loc4_:Null<Dynamic> = null;
		var _loc5_:Null<Dynamic> = null;
		var _loc6_: Null<Dynamic> = null;
		var _loc7_:Null<Dynamic> = null;
		var _loc8_:Null<Dynamic> = null;
		characterCustomDefs = [];
		var iterable:Array<Dynamic> = cast(param1, Array<Dynamic>);
		for (_loc2_ in iterable) {
			_loc3_ = [];
			_loc4_ = Std.string(_loc2_.line1).split(",");
			_loc3_.push(_loc4_);
			_loc3_.push(_loc2_.line2dep);
			if (_loc2_.line2dep == 0) {
				_loc5_ = Std.string(_loc2_.line2).split(",");
				_loc3_.push(_loc5_);
			} else {
				_loc6_ = 0;
				while (_loc6_ < 6) {
					_loc7_ = "line2-" + Std.string(_loc6_ + 1);
					if (_loc2_.hasOwnProperty(_loc7_)) {
						_loc8_ = _loc2_[_loc7_].split(",");
						_loc3_.push(_loc8_);
					}
					_loc6_++;
				}
			}
			characterCustomDefs.push(_loc3_);
		} */
	}

	public function getCatalogPlayerLevel(playerLevelId:Float):BambaPlayerLevel {
		for (playerLevel in playerLevelsCatalog) {
			if(playerLevel.level == playerLevelId ) {
				return playerLevel;
			}
		}
		return null;
		/* var _loc2_:Dynamic = null;
		_loc2_ = 0;
		while (_loc2_ < playerLevelsCatalog.length) {
			if (playerLevelsCatalog[_loc2_].level == param1) {
				return playerLevelsCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null; */
	}

	function buildMagicCatalog():Void {
		trace("building magic catalog");
		var magicBookData= JsonParser.load("Assets/json/magicBook.json");
		for (magic in magicBookData.magics) {
			var _bambaMagic = new BambaMagic(magic);
			magicCatalog.push(_bambaMagic);
		}
	}

	function buildHelpCatalog():Void {
		trace("building help catalog");
		var helpData = JsonParser.load("Assets/json/help.json");
		for (helpPage in helpData) {
			var _helpPage = new BambaHelpPage(helpPage);
			helpCatalog.push(_helpPage);
		}
}

	public function getSuitableItemId():Float {
		var _loc1_:Float = Math.NaN;
		var _loc2_:Dynamic = null;
		var _loc3_:Array<Dynamic> = null;
		var _loc4_:Dynamic = null;
		_loc1_ = playerData.level + itemsLevels[Math.floor(Math.random() * itemsLevels.length)];
		if (_loc1_ < minLevel) {
			_loc1_ = minLevel;
		}
		if (_loc1_ > maxLevel) {
			_loc1_ = maxLevel;
		}
		_loc3_ = [];
		_loc2_ = 0;
		while (_loc2_ < itemsCatalog.length) {
			if (itemsCatalog[_loc2_].minLevel == _loc1_) {
				_loc3_.push(itemsCatalog[_loc2_].id);
			}
			_loc2_++;
		}
		if (_loc3_.length > 0) {
			_loc4_ = _loc3_[Math.floor(Math.random() * _loc3_.length)];
		} else {
			_loc2_ = 0;
			while (_loc2_ < itemsCatalog.length) {
				if (itemsCatalog[_loc2_].minLevel <= _loc1_) {
					_loc3_.push(itemsCatalog[_loc2_].id);
				}
				if (_loc3_.length > 0) {
					_loc4_ = _loc3_[Math.floor(Math.random() * _loc3_.length)];
				} else {
					_loc4_ = 0;
				}
				_loc2_++;
			}
		}
		return _loc4_;
	}

	function buildQuestsCatalog():Void {
		trace("building quests catalog");
		var questData = JsonParser.load("Assets/json/quests.json");
		for ( quest in questData) {
			var _quest = new BambaQuest(quest);
			questsCatalog.push(_quest);
		}
	}

	//TODO: ReturnType BambaEnemy
	public function getCatalogEnemy(id:Float, type:Float):BambaEnemy {
		for (enemy in enemiesCatalog) {
			if(enemy.id == id && enemy.type == type ) {
				return enemy;
			}
		}
		return null;
		/* var _loc3_:Dynamic = null;
		_loc3_ = 0;
		while (_loc3_ < enemiesCatalog.length) {
			if (enemiesCatalog[_loc3_].id == param1 && enemiesCatalog[_loc3_].type == param2) {
				return enemiesCatalog[_loc3_];
			}
			_loc3_++;
		}
		return null; */
	}

	function buildPrizesCatalog():Void {
		trace("building prizes catalog");
		var prizesData = JsonParser.load("Assets/json/prizes.json");
		for (prize in prizesData) {
			var _prize = new BambaPrize(prize);
			prizesCatalog.push(_prize);
		}
		/* var _loc2_:Xml = null;
		var _loc3_:BambaPrize = null;
		for (_loc2_ in param1) {
			_loc3_ = new BambaPrize(_loc2_);
			prizesCatalog.push(_loc3_);
		} */
	}

	//TODO: return type BambaHelpPage
	public function getCatalogHelpPage(helpPageId:Float):BambaHelpPage {
		for (helpPage in helpCatalog) {
			if(helpPage.id == helpPageId) {
				return helpPage;
			}
		}
		return null;
		/* var _loc2_:Dynamic = null;
		_loc2_ = 0;
		while (_loc2_ < helpCatalog.length) {
			if (helpCatalog[_loc2_].id == param1) {
				return helpCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null; */
	}

	//Rturn type BambaItemBase
	public function getCatalogItemBase(id:Dynamic):BambaItemBase {
		for (itemBase in itemsBaseCatalog) {
			if(itemBase.id == id) {
				return itemBase;
			}
		}
		return null;
		/* var _loc2_:Dynamic = null;
		_loc2_ = 0;
		while (_loc2_ < itemsBaseCatalog.length) {
			if (itemsBaseCatalog[_loc2_].id == param1) {
				return itemsBaseCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null; */
	}

	//Retrun type BambaMagic
	public function getCatalogMagic(id:Float):BambaMagic {
		for (magic in magicCatalog) {
			if (magic.id == id ) {
				return magic;
			}
		}
		return null;

	}

	//Rreturn type BambaCard
	public function getCatalogCard(cardId:Float):BambaCard {
		for (card in cardsCatalog) {
			if (card.id == cardId) {
				return card;
			}
		}
		return null;
		/* var _currentCard: BambaCard = null;
		for (card in cardsCatalog) {
			if(card.id == cardId ) {
				_currentCard = card;
			}
		}
		return _currentCard; */
		/* var _loc2_:Dynamic = null;
		_loc2_ = 0;
		while (_loc2_ < cardsCatalog.length) {
			if (cardsCatalog[_loc2_].id == param1) {
				return cardsCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null; */
	}

	//Rreturn type BambaCard
	public function getNewCard(cardId:Float):BambaCard {
		for (card in cardsCatalog) {
			if (card.id == cardId) {
				var _newCard = new BambaCard(card.data);
				_newCard.init(game);
				return _newCard;
			}
		}
		return null;
		/* var _loc2_:Dynamic = null;
		var _loc3_:BambaCard = null;
		var _loc4_:BambaCard = null;
		_loc2_ = 0;
		while (_loc2_ < cardsCatalog.length) {
			if (cardsCatalog[_loc2_].id == param1) {
				_loc3_ = cardsCatalog[_loc2_];
				_loc4_ = new BambaCard(_loc3_.xmlData);
				_loc4_.init(game);
				return _loc4_;
			}
			_loc2_++;
		}
		return null; */
	}

	//Return Type BambaDungeonData
	public function getCatalogDungeonData(dungeonDataId:Float):BambaDungeonData {
		for (dungeonData in dungeonsDataCatalog) {
			if (dungeonData.id == dungeonDataId) {
				return dungeonData;
			}
		}
		return null;
		/* var _loc2_:Null<Dynamic> = null;
		_loc2_ = 0;
		while (_loc2_ < dungeonsDataCatalog.length) {
			if (dungeonsDataCatalog[_loc2_].id == param1) {
				return dungeonsDataCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null; */
	}

	//TODO: Rerturn type BambaStoreItems
	public function getCatalogStoreItems(param1:Dynamic, param2:Dynamic):Dynamic {
		var _loc3_:Dynamic = null;
		_loc3_ = 0;
		while (_loc3_ < storeItemsCatalog.length) {
			if (storeItemsCatalog[_loc3_].level == param1 && storeItemsCatalog[_loc3_].order == param2) {
				return storeItemsCatalog[_loc3_];
			}
			_loc3_++;
		}
		return null;
	}

	public function loadFightData(fightBoardXy: Array<String>,fightSmallBoardXy:Array<String>) {
		var _fightBoardXYArray = [];
		var _fightSmallBoardXYArray = [];
		
		for(boardString in fightBoardXy) {
			var boardRows:Array<String> = boardString.split(":");
			var processedBoard:Array<Array<String>> = [];

			for (row in boardRows) {
				processedBoard.push(row.split(','));
			}

			_fightBoardXYArray.push(processedBoard);
		}

		for (smallBoardString in fightSmallBoardXy) {
			var smallBoardRows:Array<String> = smallBoardString.split(":");
			var processedSmallBoard:Array<Array<String>> = [];
			
			for (row in smallBoardRows) {
				processedSmallBoard.push(row.split(","));
			}
			
			_fightSmallBoardXYArray.push(processedSmallBoard);
		}

		fightBoardXY = _fightBoardXYArray;
		fightSmallBoardXY = _fightSmallBoardXYArray;
	}
	/* public function loadFightData(fightBoardXy:Array<String>, fightXoffset:Array<Int>, fightZsize:Array<Float>, fightSmallBoardXy:Array<String>):Void {
		var _fightBoardXYIndex:Int = 0;
		var _boardCordsIndex:Int = 0;
		var _fightBoardXYStringArray:Array<String> = [];
		var _fightSmallBoardXYStringArray:Array<String> = [];
		var _boardcords:Array<String> = null;
		var _loc10_:Dynamic = null;
		var _currentBarCordsArray:Array<String> = null;
		var _loc12_:Array<Dynamic> = null;
		var _loc13_:Dynamic = null;
		var _loc14_:Array<Dynamic> = null;
		fightBoardXY = [];
		_fightBoardXYStringArray = fightBoardXy.split("*");
		while (_fightBoardXYIndex < _fightBoardXYStringArray.length) {
			_boardcords = _fightBoardXYStringArray[_fightBoardXYIndex].split(":");
			_loc10_ = [];
			while (_boardCordsIndex < _boardcords.length) {
				_currentBarCordsArray = _boardcords[_boardCordsIndex].split(",");
				_loc10_.push(_currentBarCordsArray);
				_boardCordsIndex++;
			}
			fightBoardXY.push(_loc10_);
			_fightBoardXYIndex++;
		}
		fightXoffset = fightXoffsetString.split(",");
		//fightZsize = fightZsize;
		fightSmallBoardXY = [];
		_fightSmallBoardXYStringArray = fightSmallBoardXYString.split("*");
		_fightBoardXYIndex = 0;
		while (_fightBoardXYIndex < _fightSmallBoardXYStringArray.length) {
			_loc12_ = _fightSmallBoardXYStringArray[_fightBoardXYIndex].split(":");
			_loc13_ = [];
			_boardCordsIndex = 0;
			while (_boardCordsIndex < _loc12_.length) {
				_loc14_ = _loc12_[_boardCordsIndex].split(",");
				_loc13_.push(_loc14_);
				_boardCordsIndex++;
			}
			fightSmallBoardXY.push(_loc13_);
			_fightBoardXYIndex++;
		}
	} */

	//Return type: BambaItem
	public function getCatalogItem(id:Float):BambaItem {
		for (item in itemsCatalog) {
			if (item.id == id) {
				return item;
			}
		}
		return null;
		/* var _loc2_:Dynamic = null;
		_loc2_ = 0;
		while (_loc2_ < itemsCatalog.length) {
			if (itemsCatalog[_loc2_].id == param1) {
				return itemsCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null; */
	}

	public function loadDungeonDifficulties(dungeonDifficulties:Array<{prizeprc:Float, enemylevels:Array<Int>, bosslevels:Array<Int>}>):Void {
		this.dungeonDifficulties = [];

		if(dungeonDifficulties != null) {
			for (difficulty in dungeonDifficulties) {
				var difficultyData:  Array<Dynamic> = [
					difficulty.bosslevels,
					difficulty.enemylevels,
					difficulty.prizeprc,
				];
				this.dungeonDifficulties.push(difficultyData);
			}
		}
	}

	public function loadPlayerData(param1:Xml):Void {
		playerData.updatePlayerData(param1);
	}

	function buildEnemiesLevelsCatalog():Void {
		trace("building enemy levels catalog");
		var enemyLevelsData = JsonParser.load("Assets/json/enemyLevels.json");
		minEnemyLevel = 99;
		maxEnemyLevel = -99;

		for (enemyLevel in enemyLevelsData.enemyLevels) {
			var _enemyLevel = new BambaEnemyLevel(enemyLevel);
			enemiesLevelsCatalog.push(_enemyLevel);
			if(minEnemyLevel > _enemyLevel.level) {
				minEnemyLevel = _enemyLevel.level;
			}

			if (maxEnemyLevel < _enemyLevel.level) {
				maxEnemyLevel = _enemyLevel.level;
			}
		}
		/* if(param1 != null) {
			var iterable:Array<Dynamic> = cast(param1, Array<Dynamic>);
			for (_loc2_ in iterable) {
				_loc3_ = new BambaEnemyLevel(_loc2_);
				enemiesLevelsCatalog.push(_loc3_);
				if (minEnemyLevel > _loc3_.level) {
					minEnemyLevel = _loc3_.level;
				}
				if (maxEnemyLevel < _loc3_.level) {
					maxEnemyLevel = _loc3_.level;
				}
			}
		} */
		
	}

	function buildSurprisesCatalog():Void {
		trace("building suprises catalog");
		var suprisesJson = JsonParser.load("Assets/json/suprises.json");
		for (data in suprisesJson.surprises) {
			var suprise = new BambaSurprise(data);
			surprisesCatalog.push(suprise);
		}
	}

	function buildItemsBaseCatalog():Void {
		trace("buildimg items base catalog");
		var itemBaseData = JsonParser.load("Assets/json/itemsBase.json");
		for (itemBase in itemBaseData.itemsBases) {
			var _itemBase = new BambaItemBase(itemBase);
			itemsBaseCatalog.push(_itemBase);
		}
		/* var _loc2_:Xml = null;
		var _loc3_:BambaItemBase = null;
		for (_loc2_ in param1) {
			_loc3_ = new BambaItemBase(_loc2_);
			itemsBaseCatalog.push(_loc3_);
		} */
	}

	//TODO: RETURN TYPE BambaQuest
	public function getCatalogQuest(param1:Dynamic):Dynamic {
		var _loc2_:Dynamic = null;
		_loc2_ = 0;
		while (_loc2_ < questsCatalog.length) {
			if (questsCatalog[_loc2_].id == param1) {
				return questsCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null;
	}

	function buildItemsCatalog():Void {
		trace("building items catalog");
		var itemsData = JsonParser.load("Assets/json/items.json");
		for (item in itemsData) {
			var _item = new BambaItem(item);
			_item.init(game);
			itemsCatalog.push(_item);
		}
		/* var _loc2_:Xml = null;
		var _loc3_:BambaItem = null;
		for (_loc2_ in param1) {
			_loc3_ = new BambaItem(_loc2_);
			_loc3_.init(game);
			itemsCatalog.push(_loc3_);
		} */
	}

	function buildCardsCatalog():Void {
		trace("building cards catalog");
		var cardsData = JsonParser.load("Assets/json/cards.json");
		for (card in cardsData.cards) {
			var _card = new BambaCard(card);
			cardsCatalog.push(_card);
		}
		/* for (_loc2_ in param1) {
			_loc3_ = new BambaCard(_loc2_);
			_loc3_.init(game);
			cardsCatalog.push(_loc3_);
		} */
	}

	public function loadOrdersStartDef(orders:Array<{magic:Array<Int>, items:Array<Int>, cards:Array<Int>}>):Void {
		this.ordersStartDefs = [];

		if (orders != null) {
			for (order in orders) {
				var orderData = [
					order.magic,
					order.cards,
					order.items,
				];
				this.ordersStartDefs.push(orderData);
			} 
		}
		/* if(param1 != null) {
			var iterable:Array<Dynamic> = cast(param1, Array<Dynamic>);
			for (_loc2_ in iterable) {
				_loc3_ = [];
				_loc4_ = Std.string(_loc2_.magic).split(",");
				_loc5_ = Std.string(_loc2_.cards).split(",");
				_loc6_ = Std.string(_loc2_.items).split(",");
				_loc3_.push(_loc4_);
				_loc3_.push(_loc5_);
				_loc3_.push(_loc6_);
				ordersStartDefs.push(_loc3_);
			}
		} */
	}

	public function loadGeneralData():Void {
		//Macro to parse generalData Json
		var data = JsonParser.load("Assets/json/generalData.json");
		
		//load fight data 
		var _fightBoardXy = data.generaldata.fightboard.fightboardxy;
		var _fightSmallBoardXy = data.generaldata.fightboard.fightsmallboardxy;
		loadFightData(_fightBoardXy, _fightSmallBoardXy);

		// Load Dungeons Difficulties
		loadDungeonDifficulties(data.generaldata.dungeondifficulties.difficulty);

		// Load Map Data;
		var _areas = data.generaldata.mainmap.areas;
		var _dungeons = data.generaldata.mainmap.dungeons;
		mapData = new BambaMapData(_areas,_dungeons);

		//Load order start Definition
		loadOrdersStartDef(data.generaldata.ordersstartdef.order);
		//Load character custom 
		
		loadCharacterCustom(data.generaldata.charactercustom.tab);

		this.mapTrails = data.generaldata.maptrails;
		this.itemsLevels = data.generaldata.itemslevels;
		this.defaultAnimLength = data.generaldata.defaultanimlength;
		this.defaultDungeonAnimLength = data.generaldata.defaultdungeonanimlength;
		this.winAnimLength = data.generaldata.winanimlength;
		this.barAnimLength = data.generaldata.baranimlength;
		this.winAnimName = data.generaldata.winanimname;
		this.beenHitAnimName = data.generaldata.beenhitanimname;
		this.loseAnimName = data.generaldata.loseanimname;
		this.sharedOrder = data.generaldata.sharedorder;
		this.fightZsize = data.generaldata.fightboard.fightzsize;
		this.fightXoffset = data.generaldata.fightboard.fightxoffset;
		this.mapTimeDef = data.generaldata.maptimedef;

		//Set map times
		mapTimes = new Map<String,Float>();
		for (key in Reflect.fields(data.generaldata.maptimes)){
			var value: Float = Reflect.field(data.generaldata.maptimes, key);
			mapTimes.set(key, value);
		}
		
	
		//var data = JsonMacro.load("F:/Projects/BambaMagicKeep/Assets/json/generalData.json");
		//var varfightBoardXY = data.generaldata.fightboard.fightboardxy;
	 /* 	var fightBoardXY = "195,285:360,285:525,285:690,285*
		165,335:347,335:540,335:720,335*
		130,400:338,400:550,400:760,400";  */
		/* var fightXoffset = "45,50,55";
		var fightZsize = "0.8,0.9,1";
		var fightSmallBoardXY = "16,17:44,17:72,17:102,17*
		16,45:44,45:72,45:102,45*
		16,73:44,73:72,73:102,73"; */
		//itemsLevels = ["-3","-2","-1","0","1"];
		//defaultAnimLength = 0.7;
		//defaultDungeonAnimLength = 0.3;
		//winAnimLength = 2;
		//barAnimLength = 1;
		//beenHitAnimName = "beenHit";
		//winAnimName = "win";
		//loseAnimName = "lose";
		//sharedOrder = 4;
		
		//loadFightData(fightBoardXY, fightXoffset, fightZsize, fightSmallBoardXY);
		//loadDungeonDifficulties();
		/* 
		loadDungeonDifficulties(param1.dungeonDifficulties.children());
		//itemsLevels = Std.string(param1.itemsLevels).split(",");
		//defaultAnimLength = param1.defaultAnimLength;
		//defaultDungeonAnimLength = param1.defaultDungeonAnimLength;
		//winAnimLength = param1.winAnimLength;
		//barAnimLength = param1.barAnimLength;
		//beenHitAnimName = param1.beenHitAnimName;
		//winAnimName = param1.winAnimName;
		//loseAnimName = param1.loseAnimName;
		//sharedOrder = param1.sharedOrder;
		//mapData = new BambaMapData(param1.mainMap);
		//loadOrdersStartDef(param1.ordersStartDef.children());
		//loadCharacterCustom(param1.characterCustom.children());
		//mapTrails = param1.mapTrails.split(",");
		//mapTimeDef = param1.mapTimeDef;
		mapTimes = [];
		_loc7_ = param1.mapTimes.split(",");
		_loc8_ = 0;
		while (_loc8_ < _loc7_.length) {
			_loc9_ = _loc7_[_loc8_].split("%");
			mapTimes.push(_loc9_);
			_loc8_++;
		} */
	}

	//TODO: type should be BambaPrize
	public function getCatalogPrize(prizeId: Float):BambaPrize {
		for (prize in prizesCatalog) {
			if (prize.id == prizeId ) {
				return prize;
			}
		}
		return null;
		/* var _loc2_:Null<Dynamic> = null;
		_loc2_ = 0;
		while (_loc2_ < prizesCatalog.length) {
			if (prizesCatalog[_loc2_].id == param1) {
				return prizesCatalog[_loc2_];
			}
			_loc2_++;
		}
		return null; */
	}

	function buildStoreItemsCatalog():Void {
		trace("building store items catalog");
		var storeItemsData = JsonParser.load("Assets/json/storeItems.json");
		for (storeItem in storeItemsData) {
			var _storeItem = new BambaStoreItems(storeItem);
			storeItemsCatalog.push(_storeItem);
		}
		/* var _loc2_:Xml = null;
		var _loc3_:BambaStoreItems = null;
		for (_loc2_ in param1) {
			_loc3_ = new BambaStoreItems(_loc2_);
			storeItemsCatalog.push(_loc3_);
		} */
	}

	function buildPlayerLevelsCatalog():Void {
		trace("building players level catalog");
		var playerLevelsData = JsonParser.load("Assets/json/playerLevels.json");
		minLevel = 99;
		maxLevel = -99;
		for (playerLevel in playerLevelsData) {
			var _playerLevel = new BambaPlayerLevel(playerLevel);

			if(minLevel > _playerLevel.level) {
				minLevel = _playerLevel.level;
			};
	
			if(maxLevel < _playerLevel.level) {
				maxLevel = _playerLevel.level;
			}

			playerLevelsCatalog.push(_playerLevel);
		}
	}
}
