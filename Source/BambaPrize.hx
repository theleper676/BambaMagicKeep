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

	public function new(param1:Xml) {
		for (node in param1.elements()) {
			id = Std.parseFloat(node.elementsNamed("id").next()?.firstChild().nodeValue);
			numOfItems = Std.parseFloat(node.elementsNamed("numOfItems").next()?.firstChild().nodeValue);
			itemChance = Std.parseFloat(node.elementsNamed("itemChance").next()?.firstChild().nodeValue);
			fixed = Std.parseFloat(node.elementsNamed("fixed").next()?.firstChild().nodeValue);
			money = Std.parseFloat(node.elementsNamed("money").next()?.firstChild().nodeValue);
			moneyChance = Std.parseFloat(node.elementsNamed("moneyChance").next()?.firstChild().nodeValue);
			ingredient1 = Std.parseFloat(node.elementsNamed("ingredient1").next()?.firstChild().nodeValue);
			ingredient1Chance = Std.parseFloat(node.elementsNamed("ingredient1Chance").next()?.firstChild().nodeValue);
			ingredient2 = Std.parseFloat(node.elementsNamed("ingredient2").next()?.firstChild().nodeValue);
			ingredient2Chance = Std.parseFloat(node.elementsNamed("ingredient2Chance").next()?.firstChild().nodeValue);
			ingredient3 = Std.parseFloat(node.elementsNamed("ingredient3").next()?.firstChild().nodeValue);
			ingredient3Chance = Std.parseFloat(node.elementsNamed("ingredient3Chance").next()?.firstChild().nodeValue);
			ingredient4 = Std.parseFloat(node.elementsNamed("ingredient4").next()?.firstChild().nodeValue);
			ingredient4Chance = Std.parseFloat(node.elementsNamed("ingredient4Chance").next()?.firstChild().nodeValue);
		}
	
	}
}
