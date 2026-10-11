package utils;

import openfl.text.Font;
import swf.exporters.animate.AnimateDynamicTextSymbol;
import swf.exporters.animate.AnimateLibrary;

/**
	Matches each dynamic text field to one of the project's embedded fonts.

	`AnimateDynamicTextSymbol.__createObject()` decides whether to embed a font by walking
	`Font.enumerateFonts()` and comparing `font.fontName` - the TTF's *internal* family name, not
	the `id` given in project.xml. Its only fallback strips non-letters and compares with
	`substr()`, which is **case sensitive**, so a SWF asking for "choco" never finds the embedded
	"Choco": `"Choco".substr(0, 5) != "choco"`. The field then gets `embedFonts = false`.

	That is not a harmless fallback. On native, `TextEngine.findFont()` only looks through the
	registered fonts and then tries the name as a *file path* - there is no lookup of installed
	fonts by name - so an unmatched name resolves to null and the field silently drops to the
	`_sans` default set (system Arial). And because the Flash authors encoded weight in the font
	*name* rather than the bold flag, which the exporter never sets, "Arial Bold" renders as plain
	system Arial regardless.

	Of the 161 dynamic text fields in this project, 38 were falling back this way: "choco" (14)
	and "petel" (1) were pure casing, "Petel" (2) had no TTF until one was added, and
	"Arial Bold" (21) still has none - see ALIASES.

	Resolution order per field, most faithful first:

	  1. exact match against a registered font - left alone, this is the common case
	     ("Arial" x64, "Choco" x54, "Petel" x2, "Choco Bold" x2, "Footlight MT Light" x1)
	  2. case- and whitespace-insensitive match - rewritten to the registered spelling, which is
	     what rescues "choco"
	  3. an explicit entry in ALIASES, for a face this project does not ship
	  4. otherwise left untouched, so the engine's own fallback still applies, and logged

	Device font names ("_sans", "_serif", "_typewriter") are left alone - the exporter already
	treats them as found, and OpenFL maps them to its default font sets.
**/
@:access(swf.exporters.animate)
class FontBinder {
	/**
		Substitutes for fonts the original FLAs used but this project has no TTF for. Keyed by
		normalized (lowercased, whitespace-stripped) requested name; the value must be the exact
		internal name of an embedded font.

		"Arial Bold" now has its own embedded face (Assets/fonts/Arial_Bold.ttf), so the alias below
		only applies if that file is removed. It maps to Arial, which covers the Hebrew block the
		game is written in. This loses nothing against the previous behaviour: the name already fell
		through to the system Arial regular that `_sans` resolves to, because the exporter never
		sets `TextFormat.bold` and `TextEngine.findFont()` cannot look up an installed font by
		name on native. The alias only makes that choice explicit, embedded and identical on
		every target.

		Dropping a real TTF into Assets/fonts and project.xml takes precedence automatically,
		since an exact match is tried first - that is how Petel stopped needing an alias, and
		how you would restore true bold here with an actual Arial Bold face.
	**/
	static var ALIASES:Map<String, String> = [
		"arialbold" => "Arial",
	];

	static inline function normalize(name:String):String {
		return StringTools.replace(name, " ", "").toLowerCase();
	}

	public static function apply(library:AnimateLibrary):Void {
		if (library == null) return;
		// Registered name -> itself, plus a normalized index for the case-insensitive pass.
		var exact = new Map<String, Bool>();
		var normalized = new Map<String, String>();
		for (font in Font.enumerateFonts()) {
			if (font == null || font.fontName == null) continue;
			exact.set(font.fontName, true);
			normalized.set(normalize(font.fontName), font.fontName);
		}
		if (!exact.keys().hasNext()) {
			trace("FontBinder: no fonts registered - nothing to match against");
			return;
		}

		var rebound = 0;
		var aliased = 0;
		var unresolved = [];
		for (symbol in library.symbols) {
			if (symbol == null || !Std.isOfType(symbol, AnimateDynamicTextSymbol)) continue;
			var textSymbol:AnimateDynamicTextSymbol = cast symbol;
			var requested = textSymbol.fontName;
			if (requested == null || requested == "") continue;
			switch (requested) {
				case "_sans", "_serif", "_typewriter":
					continue;
				default:
			}
			if (exact.exists(requested)) continue;

			var key = normalize(requested);
			var match = normalized.get(key);
			if (match != null) {
				textSymbol.fontName = match;
				rebound++;
				continue;
			}

			var alias = ALIASES.get(key);
			if (alias != null && exact.exists(alias)) {
				textSymbol.fontName = alias;
				aliased++;
				continue;
			}

			unresolved.push(requested);
		}

		trace("FontBinder " + (library.uuid != null ? library.uuid : library.id)
			+ ": rebound " + rebound + ", aliased " + aliased + ", unresolved " + unresolved.length
			+ (unresolved.length > 0 ? " " + unresolved.slice(0, 5) : ""));
	}
}
