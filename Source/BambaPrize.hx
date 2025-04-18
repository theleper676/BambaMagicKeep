package;

import flash.display.*;

class BambaPrize {
	public var money:Float;

	public var ingredient3:Float;

	public var numOfItems:Float;

	public var ingredient1:Float;

	public var ingredient2:Float;

	public var ingredient4:Float;

	public var moneyChance:Float;

	public var ingredient4Chance:Float;

	public var ingredient1Chance:Float;

	public var ingredient2Chance:Float;

	public var ingredient3Chance:Float;

	public var id:Float;

	public var itemChance:Float;

	public var fixed:Float;

	public function new(prize:{numofitems:Int, moneychance:Float, money:Int, itemchance:Float, ingredient4chance:Float, ingredient4:Int, ingredient3chance:Float, ingredient3:Int, ingredient2chance:Float, ingredient2:Int, ingredient1chance:Float, ingredient1:Int, id:Int}) {
		this.id = prize.id;
		this.numOfItems = prize.numofitems;
		this.itemChance = prize.itemchance;
		this.fixed = 0;
		this.money = prize.money;
		this.moneyChance = prize.moneychance;
		this.ingredient1 = prize.ingredient1;
		this.ingredient1Chance = prize.ingredient1chance;
		this.ingredient2 = prize.ingredient2;
		this.ingredient2Chance = prize.ingredient2chance;
		this.ingredient3 = prize.ingredient3;
		this.ingredient3Chance = prize.ingredient3chance;
		this.ingredient4 = prize.ingredient4;
		this.ingredient4Chance = prize.ingredient4chance;
		/* for (node in param1.elements()) {
			//id = Std.parseFloat(node.elementsNamed("id").next()?.firstChild().nodeValue);
			//numOfItems = Std.parseFloat(node.elementsNamed("numOfItems").next()?.firstChild().nodeValue);
			//itemChance = Std.parseFloat(node.elementsNamed("itemChance").next()?.firstChild().nodeValue);
			//fixed = Std.parseFloat(node.elementsNamed("fixed").next()?.firstChild().nodeValue);
			//money = Std.parseFloat(node.elementsNamed("money").next()?.firstChild().nodeValue);
			//moneyChance = Std.parseFloat(node.elementsNamed("moneyChance").next()?.firstChild().nodeValue);
			//ingredient1 = Std.parseFloat(node.elementsNamed("ingredient1").next()?.firstChild().nodeValue);
			//ingredient1Chance = Std.parseFloat(node.elementsNamed("ingredient1Chance").next()?.firstChild().nodeValue);
			//ingredient2 = Std.parseFloat(node.elementsNamed("ingredient2").next()?.firstChild().nodeValue);
			//ingredient2Chance = Std.parseFloat(node.elementsNamed("ingredient2Chance").next()?.firstChild().nodeValue);
			//ingredient3 = Std.parseFloat(node.elementsNamed("ingredient3").next()?.firstChild().nodeValue);
			//ingredient3Chance = Std.parseFloat(node.elementsNamed("ingredient3Chance").next()?.firstChild().nodeValue);
			//ingredient4 = Std.parseFloat(node.elementsNamed("ingredient4").next()?.firstChild().nodeValue);
			//ingredient4Chance = Std.parseFloat(node.elementsNamed("ingredient4Chance").next()?.firstChild().nodeValue);
		} */
	
	}
}
