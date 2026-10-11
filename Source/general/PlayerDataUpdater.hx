package general;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.text.TextField;
import openfl.geom.Rectangle;

/**
	Fills the shared HUD panels - name/order/level, money and ingredients, xp and stats - that
	most screens embed.

	Every method takes the panel as `Dynamic`, because each screen embeds its *own* generated
	clip class (`BambaStore`'s moneyMC is not the same type as `BambaQuestManager`'s) and there
	is no common supertype to name. That much has to stay.

	What could not stay is reaching *through* that Dynamic: `param1.moneyDT.text = ...` makes
	the `.text` assignment a reflective property set, and hxcpp rejects those once DCE has
	trimmed the entry, with `Error : Invalid field:text`. Reading the child off the Dynamic is
	fine - that resolves through the generated `@:keep` field - so each child is now fetched
	reflectively *once* and cast to its real type, after which `.text` and `.width` compile to
	direct property access. Same fix the rest of this port uses for Dynamic-typed clips.

	The helpers also tolerate a missing child. These panels are not identical across screens,
	and a reflective set on a field a particular clip does not have would throw; skipping it
	leaves that one label blank instead of taking the game down.
**/
class PlayerDataUpdater {
	static var game:BambaMain;

	public function new() {}

	public static function init(mainGame:BambaMain):Void {
		game = mainGame;
	}

	// ---- typed access into a Dynamic panel ------------------------------------------------

	static function child(container:Dynamic, name:String):Dynamic {
		if (container == null) return null;
		return Reflect.field(container, name);
	}

	static function textFieldOf(container:Dynamic, name:String):TextField {
		var found = child(container, name);
		if (found == null || !Std.isOfType(found, TextField)) {
			if (found == null) trace("PlayerDataUpdater: no text field '" + name + "' on this panel");
			return null;
		}
		return cast found;
	}

	static function clipOf(container:Dynamic, name:String):DisplayObject {
		var found = child(container, name);
		if (found == null || !Std.isOfType(found, DisplayObject)) return null;
		return cast found;
	}

	static function containerOf(container:Dynamic, name:String):DisplayObjectContainer {
		var found = child(container, name);
		if (found == null || !Std.isOfType(found, DisplayObjectContainer)) return null;
		return cast found;
	}

	/** Assigns to a panel's text field if it has one. **/
	static function setText(container:Dynamic, name:String, value:String):Void {
		var field = textFieldOf(container, name);
		if (field != null) field.text = value;
	}

	/**
		Same, through the Hebrew right-to-left reflow. `Heb.setText` dereferences both arguments
		on its first line, so neither a missing field nor a missing dictionary string can be
		handed to it.
	**/
	static function setHeb(container:Dynamic, name:String, value:String):Void {
		if (value == null) return;
		var field = textFieldOf(container, name);
		if (field != null) Heb.setText(field, value);
	}

	/**
		How Flash rendered a number dropped into a text field: whole values with no decimal
		point. Haxe would otherwise print "555" or "555.0" depending on the target.
	**/
	static function numText(value:Float):String {
		if (Math.isNaN(value)) return "0";
		return value == Math.ffloor(value) ? Std.string(Std.int(value)) : Std.string(value);
	}

	/**
		`gotoAndStop(label)` throws `Error #2109` when the clip has no such label, and the
		equipment slot clips are not identical across screens - the character screen's baby does
		not carry the "disable" frame the store's does. Falls back to the first frame, which is
		the empty state the original used for a slot with nothing in it.
	**/
	static function gotoLabel(clip:MovieClip, label:String):Void {
		if (clip == null) return;
		var labels = clip.currentLabels;
		if (labels != null) {
			for (frameLabel in labels) {
				if (frameLabel.name == label) {
					clip.gotoAndStop(label);
					return;
				}
			}
		}
		clip.gotoAndStop(1);
	}

	// ---- panels ---------------------------------------------------------------------------

	public static function updateMoneyData(param1:Dynamic):Void {
		var data = game.gameData.playerData;
		setText(param1, "moneyDT", numText(data.money));
		setText(param1, "ingredient1DT", numText(data.ingredient1));
		setText(param1, "ingredient2DT", numText(data.ingredient2));
		setText(param1, "ingredient3DT", numText(data.ingredient3));
		setText(param1, "ingredient4DT", numText(data.ingredient4));
	}

	public static function updateProgressData(param1:Dynamic):Void {
		var data = game.gameData.playerData;
		var dictionary = game.gameData.dictionary;

		setHeb(param1, "EXPOINTS", dictionary.EXPOINTS);
		setHeb(param1, "exPointsDT", numText(data.exPoints));

		var nextLevelEx:Float = game.gameData.getCatalogPlayerLevel(data.level).nextLevelEx;
		setHeb(param1, "NEXT_LEVEL", dictionary.NEXT_LEVEL);
		setHeb(param1, "exPointsNextDT", numText(nextLevelEx));

		var thisLevelEx:Float = data.level > 1 ? game.gameData.getCatalogPlayerLevel(data.level - 1).nextLevelEx : 0;

		// The xp bar is a mask inside a nested clip, so this is two reflective hops before a
		// typed .width. Guard against a zero span as well as a missing clip: on the last level
		// nextLevelEx can equal thisLevelEx, and the original divided by it regardless.
		var xpMask = clipOf(child(param1, "xpBarMC"), "maskMC");
		if (xpMask != null) {
			var span = nextLevelEx - thisLevelEx;
			var filled = span > 0 ? (data.exPoints - thisLevelEx) / span : 1;
			if (filled < 0) filled = 0;
			if (filled > 1) filled = 1;
			xpMask.width = 150 * filled;
		}

		setHeb(param1, "LIFE", dictionary.LIFE + " ");
		setHeb(param1, "MAGIC", dictionary.MAGIC + " ");
		setHeb(param1, "REGENERATION", dictionary.REGENERATION + " ");
		setText(param1, "lifeDT", numText(data.maxLife));
		setText(param1, "magicDT", numText(data.maxMagic));
		setText(param1, "regenerationDT", numText(data.roundRegeneration));
	}

	public static function updateBasicData(param1:Dynamic):Void {
		var data = game.gameData.playerData;
		var dictionary = game.gameData.dictionary;

		setHeb(param1, "CHARACTER_NAME", dictionary.CHARACTER_NAME + " ");
		setHeb(param1, "CHARACTER_ORDER", dictionary.CHARACTER_ORDER + " ");
		setHeb(param1, "CHARACTER_LEVEL", dictionary.CHARACTER_LEVEL + " ");
		setHeb(param1, "nameDT", data.pName);

		// orderCode is 0 until a character has been built, which would index orders[-1].
		var orders:Array<String> = dictionary.ORDERS.split(",");
		var orderIndex = data.orderCode - 1;
		if (orderIndex >= 0 && orderIndex < orders.length) {
			setHeb(param1, "orderDT", orders[orderIndex]);
		}
		setText(param1, "levelDT", numText(data.level));
	}

	public static function setBaby(param1:Dynamic, param2:Dynamic):Void {
		var slots = ["hatMC", "capeMC", "beltMC", "shoesMC", "stickMC"];
		for (slot in slots) {
			var slotClip = child(param1, slot);
			if (slotClip == null) continue;
			if (Std.isOfType(slotClip, MovieClip)) gotoLabel(cast slotClip, "disable");
			var itemHolder = containerOf(slotClip, "itemMC");
			if (itemHolder == null) continue;
			while (itemHolder.numChildren > 0) {
				itemHolder.removeChildAt(0);
			}
		}

		var inUse:Array<Dynamic> = game.gameData.playerData.itemsInUse;
		for (itemId in inUse) {
			var item = game.gameData.getCatalogItem(itemId);
			if (item == null || item.iType >= 6) continue;
			item.generateMC();
			item.addClickEventOnBaby(param2);
			var slotIndex = Std.int(item.iType) - 1;
			if (slotIndex < 0 || slotIndex >= slots.length) continue;
			var itemHolder = containerOf(child(param1, slots[slotIndex]), "itemMC");
			if (itemHolder != null) itemHolder.addChild(item.mc);
		}
	}

	public static function setItems(param1:Dynamic, param2:Dynamic, param3:Dynamic, param4:Dynamic):Void {
		var holder:DisplayObjectContainer = (param1 != null && Std.isOfType(param1, DisplayObjectContainer)) ? cast param1 : null;
		if (holder == null) {
			trace("PlayerDataUpdater.setItems: item holder is not a container");
			return;
		}

		// Everything owned, minus whatever is currently equipped.
		var spare:Array<Dynamic> = [].concat(game.gameData.playerData.items);
		var inUse:Array<Dynamic> = game.gameData.playerData.itemsInUse;
		for (equipped in inUse) {
			for (i in 0...spare.length) {
				if (spare[i] == equipped) {
					spare.splice(i, 1);
					break;
				}
			}
		}
		spare.sort((a, b) -> a - b);

		while (holder.numChildren > 0) {
			holder.removeChildAt(0);
		}

		var placed = 0;
		for (itemId in spare) {
			var catalogItem = game.gameData.getCatalogItem(itemId);
			if (catalogItem == null) {
				trace("PlayerDataUpdater.setItems: item " + itemId + " is not in the catalog");
				continue;
			}
			var item = new BambaItem(catalogItem.data);
			item.init(game);
			item.generateMC();
			holder.addChild(item.mc);
			item.mc.x = 152 + 9 - placed % 3 * 76;
			item.mc.y = 11 + Math.floor(placed / 3) * 52;
			item.addClickEvent(param3, placed, param4);
			placed++;
		}

		// A spacer that gives the pane something to scroll to once the grid overflows.
		var visibleRows = param4 == 2 ? 24 : 27;
		if (placed > visibleRows) {
			var spacer = new MovieClip();
			spacer.graphics.drawRect(9, 0, 1, 1);
			holder.addChild(spacer);
			spacer.y = Math.floor(placed / 3) * 52 + 20;
		}

		// itemsSP was an fl.containers.ScrollPane, which OpenFL lacks; ClipScroller does its job.
		// The rectangles are each screen's itemsSP placement in the SWF (store / character).
		var screen = holder.parent;
		if (screen != null) {
			var area = param4 == 2 ? new Rectangle(348.5, 67, 240, 425) : new Rectangle(322.2, 69.85, 253, 476);
			var pane:DisplayObject = (param2 != null && Std.isOfType(param2, DisplayObject)) ? cast param2 : null;
			utils.ClipScroller.of(screen, holder, pane, area).refresh();
		}
	}
}
