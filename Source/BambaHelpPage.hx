package;

/**
	One help page from help.json. BambaHelp.showPage() reads each list as [clip name, value]
	pairs, as the AS3 original built them from help.xml: texts ["P1", text], pics
	["PIC1", path], links ["L1", target page id, label]. The JSON stores texts and links as
	{p1:…}/{l1:"id*label"} objects and pics as a plain array, so they are converted here -
	passing them through unconverted left every page without its text, pictures and links.
**/
class BambaHelpPage {
	static inline var MAX_ENTRIES = 20;

	public var texts:Array<Array<String>> = [];

	public var pics:Array<Array<String>> = [];

	public var links:Array<Array<Dynamic>> = [];

	public var template:String;

	public var id:Int;

	public function new(helpPageData:Dynamic) {
		id = helpPageData.id;
		template = helpPageData.template;

		for (i in 1...MAX_ENTRIES + 1) {
			var text:String = helpPageData.texts != null ? Reflect.field(helpPageData.texts, "p" + i) : null;
			if (text != null) texts.push(["P" + i, text]);
		}

		var picPaths:Array<String> = helpPageData.pics != null ? helpPageData.pics : [];
		for (i in 0...picPaths.length) {
			pics.push(["PIC" + (i + 1), picPaths[i]]);
		}

		for (i in 1...MAX_ENTRIES + 1) {
			var link:String = helpPageData.links != null ? Reflect.field(helpPageData.links, "l" + i) : null;
			if (link == null) continue;
			var parts = link.split("*");
			links.push(["L" + i, Std.parseFloat(parts[0]), parts.length > 1 ? parts[1] : null]);
		}
	}
}
