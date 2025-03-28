package;

import openfl.display.*;

class BambaEnemyLevel {
	public var maxLife:Float;

	public var level:Float;

	public var maxMagic:Float;

	public var exPoints:Float;

	public var roundRegeneration:Float;

	public var type:Float;

	public function new(param1:Xml) {
      for (node in param1.elements()) {
			level = Std.parseFloat(node.elementsNamed("level").next()?.firstChild().nodeValue);
         type = Std.parseFloat(node.elementsNamed("type").next()?.firstChild().nodeValue);
			maxLife = Std.parseFloat(node.elementsNamed("maxLife").next()?.firstChild().nodeValue);
			maxMagic = Std.parseFloat(node.elementsNamed("maxMagic").next()?.firstChild().nodeValue);
         roundRegeneration = Std.parseFloat(node.elementsNamed("roundRegeneration").next()?.firstChild().nodeValue);
         exPoints = Std.parseFloat(node.elementsNamed("exPoints").next()?.firstChild().nodeValue);
		}
		//level = param1.level;
		//type = param1.type;
		//maxLife = param1.maxLife;
		//maxMagic = param1.maxMagic;
		//roundRegeneration = param1.roundRegeneration;
		//exPoints = param1.exPoints;
	}
}
