package;

class BambaStoreItems {
	public var items:Array<Dynamic>;

	public var level:Float;

	public var order:Float;

	public function new(param1:Xml) {
      for (node in param1.elements()) {
			level = Std.parseFloat(node.elementsNamed("level").next()?.firstChild().nodeValue);
         order = Std.parseFloat(node.elementsNamed("order").next()?.firstChild().nodeValue);
			items = node.elementsNamed("items").next()?.firstChild().nodeValue.split(",");
		}
		/* level = param1.level;
		order = param1.order;
		items = param1.items.split(","); */
	}
}
