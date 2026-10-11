package utils;

/**
	A list of ids from the JSON data, whatever shape it came in.

	The original XML held these as comma-separated strings ("1,1,2,4"), which AS3 split into
	arrays. The XML -> JSON conversion turned single-entry lists into bare numbers
	(`"prizesids": 2`), so code that indexes them as arrays got nothing back - a null prize
	and a crash. This accepts a number, an array, or a "1,2" string.
**/
class IdList {
	public static function parse(value:Dynamic):Array<Float> {
		if (value == null) return [];
		if (Std.isOfType(value, Array)) {
			var items:Array<Dynamic> = value;
			return [for (item in items) toId(item)];
		}
		if (Std.isOfType(value, String)) {
			return [for (part in (value : String).split(",")) if (StringTools.trim(part) != "") Std.parseFloat(part)];
		}
		return [toId(value)];
	}

	static function toId(item:Dynamic):Float {
		return Std.isOfType(item, String) ? Std.parseFloat(item) : (item : Float);
	}
}
