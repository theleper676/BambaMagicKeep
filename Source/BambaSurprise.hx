package;

import openfl.display.*;

class BambaSurprise  {
	public var sDesc:String;

	public var prizesIds:Array<Dynamic>;

	public var type:Float;

	public var id:Float;

	public var sName:String;

	public function new(param1:Xml) {
		
		for (node in param1.elements()) {
			id = Std.parseFloat(node.elementsNamed("id").next()?.firstChild().nodeValue);
			sName = node.elementsNamed("name").next()?.firstChild().nodeValue;
			sDesc = node.elementsNamed("desc").next()?.firstChild().nodeValue;
			type = Std.parseFloat(node.elementsNamed("type").next()?.firstChild().nodeValue);
		}
		if (param1.exists("prizesIds")) {
			prizesIds = param1.get("prizesIds").split(",");
		} else {
			prizesIds = [];
		}
	}
}
