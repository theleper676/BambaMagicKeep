package utils;

import general.Heb;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
	In-game replacement for the native "open save file" dialog. Sits inside the game sprite,
	so it stays above the opening screen and inside the design canvas (940x650) - no OS
	window, so fullscreen is not disturbed.

	Lists every file `LocalPlayerStore.listSaves()` returns, showing character name, level
	and the time of the last save, newest first. Clicking a row calls `onSelect(path)`;
	the cancel button or clicking outside the panel calls `onCancel()`. The picker is
	modal within the game: a dim backdrop below the panel swallows clicks.
**/
class SavePicker {
	// Panel geometry, in design coordinates (BambaMain's scrollRect is 940x650).
	static inline var STAGE_W = BambaMain.DESIGN_WIDTH;
	static inline var STAGE_H = BambaMain.DESIGN_HEIGHT;
	static inline var PANEL_W = 500;
	static inline var PANEL_H = 420;
	static inline var ROW_H = 48;
	static inline var LIST_PAD = 18;

	// Hebrew is embedded under this family name (project.xml bundles Petel.ttf).
	static inline var FONT_HEB = "Petel";
	static inline var FONT_NUM = "Arial";

	/**
		Add a save picker to `parent`, filling the design canvas. `onSelect` fires with the
		chosen file path and the picker removes itself; `onCancel` fires on cancel/outside
		click and does the same. Returns the picker sprite so callers can hide it manually.
	**/
	public static function show(parent:DisplayObjectContainer, onSelect:String->Void, onCancel:Void->Void):Sprite {
		var saves = collectSaves();

		var root = new Sprite();
		parent.addChild(root);

		// Dim backdrop. Covers the full design canvas and eats clicks that miss the panel
		// (treated as cancel). The scrollRect on BambaMain keeps us inside 940x650.
		var dim = new Shape();
		dim.graphics.beginFill(0x000000, 0.6);
		dim.graphics.drawRect(0, 0, STAGE_W, STAGE_H);
		dim.graphics.endFill();
		root.addChild(dim);

		// Panel.
		var panel = new Sprite();
		panel.x = (STAGE_W - PANEL_W) / 2;
		panel.y = (STAGE_H - PANEL_H) / 2;
		root.addChild(panel);

		var bg = new Shape();
		bg.graphics.lineStyle(2, 0xC9A86A, 1);
		bg.graphics.beginFill(0x1A1510, 0.97);
		bg.graphics.drawRoundRect(0, 0, PANEL_W, PANEL_H, 16);
		bg.graphics.endFill();
		panel.addChild(bg);

		var title = textField("בחר דמות", 24, 0xF2E2B4, PANEL_W, true);
		title.x = 0;
		title.y = 10;
		title.autoSize = TextFieldAutoSize.NONE;
		var titleFormat = new TextFormat(FONT_HEB, 24, 0xF2E2B4, true);
		titleFormat.align = TextFormatAlign.CENTER;
		title.defaultTextFormat = titleFormat;
		Heb.setText(title, "בחר דמות");
		panel.addChild(title);

		// Divider under title.
		var divider = new Shape();
		divider.graphics.beginFill(0xC9A86A, 0.5);
		divider.graphics.drawRect(LIST_PAD, 48, PANEL_W - LIST_PAD * 2, 1);
		divider.graphics.endFill();
		panel.addChild(divider);

		// Rows area: masked, scrollable with the mouse wheel.
		var rowsArea = new Sprite();
		rowsArea.x = LIST_PAD;
		rowsArea.y = 58;
		var areaW = PANEL_W - LIST_PAD * 2;
		var areaH = PANEL_H - 58 - 60; // leave room for the cancel button

		var mask = new Shape();
		mask.graphics.beginFill(0x000000);
		mask.graphics.drawRect(rowsArea.x, rowsArea.y, areaW, areaH);
		mask.graphics.endFill();
		panel.addChild(mask);
		panel.addChild(rowsArea);
		rowsArea.mask = mask;

		if (saves.length == 0) {
			var empty = textField("אין קבצי שמירה. התחל משחק חדש.", 16, 0xE8D4A2, areaW, false);
			empty.y = 20;
			rowsArea.addChild(empty);
		}

		var rowsHolder = new Sprite();
		rowsArea.addChild(rowsHolder);

		var close = function(result:Null<String>) {
			if (root.parent != null) root.parent.removeChild(root);
			if (result != null) {
				if (onSelect != null) onSelect(result);
			} else {
				if (onCancel != null) onCancel();
			}
		};

		for (i in 0...saves.length) {
			var save = saves[i];
			var row = buildRow(save, areaW);
			row.y = i * (ROW_H + 4);
			row.addEventListener(MouseEvent.CLICK, function(_) close(save.path));
			rowsHolder.addChild(row);
		}

		// Mouse wheel scroll inside the list.
		var totalH = saves.length * (ROW_H + 4);
		if (totalH > areaH) {
			rowsArea.addEventListener(openfl.events.MouseEvent.MOUSE_WHEEL, function(e:openfl.events.MouseEvent) {
				rowsHolder.y = Math.max(areaH - totalH, Math.min(0, rowsHolder.y + e.delta * 20));
			});
		}

		// Cancel button.
		var cancel = buildCancelButton();
		cancel.x = (PANEL_W - cancel.width) / 2;
		cancel.y = PANEL_H - 48;
		cancel.addEventListener(MouseEvent.CLICK, function(_) close(null));
		panel.addChild(cancel);

		// Outside-panel click cancels.
		dim.addEventListener(MouseEvent.CLICK, function(_) close(null));

		return root;
	}

	static function collectSaves():Array<Dynamic> {
		var paths = utils.LocalPlayerStore.listSaves();
		var out:Array<Dynamic> = [];
		for (path in paths) {
			var desc = utils.LocalPlayerStore.describeSave(path);
			if (desc != null) out.push(desc);
		}
		// Newest first: `saved` is Date.now().toString() ("YYYY-MM-DD HH:MM:SS"), so string
		// compare is already chronological.
		out.sort(function(a, b) {
			var av:String = a.saved == null ? "" : a.saved;
			var bv:String = b.saved == null ? "" : b.saved;
			if (av == bv) return 0;
			return av < bv ? 1 : -1;
		});
		return out;
	}

	static function buildRow(save:Dynamic, width:Float):Sprite {
		var row = new Sprite();

		var bg = new Shape();
		bg.graphics.beginFill(0x2A2218, 1);
		bg.graphics.drawRoundRect(0, 0, width, ROW_H, 8);
		bg.graphics.endFill();
		row.addChild(bg);

		// Highlight on hover.
		row.addEventListener(MouseEvent.MOUSE_OVER, function(_) {
			bg.graphics.clear();
			bg.graphics.beginFill(0x4A3822, 1);
			bg.graphics.drawRoundRect(0, 0, width, ROW_H, 8);
			bg.graphics.endFill();
		});
		row.addEventListener(MouseEvent.MOUSE_OUT, function(_) {
			bg.graphics.clear();
			bg.graphics.beginFill(0x2A2218, 1);
			bg.graphics.drawRoundRect(0, 0, width, ROW_H, 8);
			bg.graphics.endFill();
		});
		row.buttonMode = true;
		row.useHandCursor = true;
		row.mouseChildren = false;

		// Character name = save file name (minus .bmksave), which is the user name typed at
		// sign-up. pName inside the JSON stays empty until a character is built, so showing
		// that would read "דמות ללא שם" for every brand-new save.
		var pName:String = fileName(save.path);
		var name = textField(pName, 20, 0xF2E2B4, width - 16, true);
		name.autoSize = TextFieldAutoSize.NONE;
		var nf = new TextFormat(FONT_HEB, 20, 0xF2E2B4, true);
		nf.align = TextFormatAlign.RIGHT;
		name.defaultTextFormat = nf;
		Heb.setText(name, pName);
		name.x = 8;
		name.y = 4;
		name.width = width - 16;
		row.addChild(name);

		// Level + saved date on the left (LTR numerals).
		var meta = "level " + Std.string(save.level);
		var savedStr:String = save.saved != null ? Std.string(save.saved) : "";
		if (savedStr != "") meta += "   " + prettyDate(savedStr);
		var metaField = textField(meta, 13, 0xC9A86A, width - 16, false);
		metaField.autoSize = TextFieldAutoSize.NONE;
		var mf = new TextFormat(FONT_NUM, 13, 0xC9A86A);
		mf.align = TextFormatAlign.LEFT;
		metaField.defaultTextFormat = mf;
		metaField.text = meta;
		metaField.x = 8;
		metaField.y = 26;
		metaField.width = width - 16;
		row.addChild(metaField);

		return row;
	}

	// "2026-10-10 17:22:45" from Date.toString() -> "2026-10-10 17:22" for display.
	static function prettyDate(saved:String):String {
		if (saved.length >= 16) return saved.substr(0, 16);
		return saved;
	}

	// Save file basename without the ".bmksave" extension. The file name is the user name
	// LocalPlayerStore sanitised at sign-up and uniquely identifies the save on disk.
	static function fileName(path:String):String {
		if (path == null) return "";
		var i = path.lastIndexOf("/");
		var j = path.lastIndexOf("\\");
		var cut = i > j ? i : j;
		var name = cut >= 0 ? path.substr(cut + 1) : path;
		var ext = utils.LocalPlayerStore.SAVE_EXTENSION;
		if (StringTools.endsWith(name.toLowerCase(), ext)) name = name.substr(0, name.length - ext.length);
		return name;
	}

	static function buildCancelButton():Sprite {
		var btn = new Sprite();
		var w = 120;
		var h = 36;
		var bg = new Shape();
		bg.graphics.lineStyle(1, 0xC9A86A, 1);
		bg.graphics.beginFill(0x2A2218, 1);
		bg.graphics.drawRoundRect(0, 0, w, h, 10);
		bg.graphics.endFill();
		btn.addChild(bg);

		var label = textField("בטל", 16, 0xF2E2B4, w, true);
		label.autoSize = TextFieldAutoSize.NONE;
		var fmt = new TextFormat(FONT_HEB, 16, 0xF2E2B4, true);
		fmt.align = TextFormatAlign.CENTER;
		label.defaultTextFormat = fmt;
		Heb.setText(label, "בטל");
		label.y = 7;
		label.width = w;
		btn.addChild(label);

		btn.buttonMode = true;
		btn.useHandCursor = true;
		btn.mouseChildren = false;
		btn.addEventListener(MouseEvent.MOUSE_OVER, function(_) {
			bg.graphics.clear();
			bg.graphics.lineStyle(1, 0xC9A86A, 1);
			bg.graphics.beginFill(0x4A3822, 1);
			bg.graphics.drawRoundRect(0, 0, w, h, 10);
			bg.graphics.endFill();
		});
		btn.addEventListener(MouseEvent.MOUSE_OUT, function(_) {
			bg.graphics.clear();
			bg.graphics.lineStyle(1, 0xC9A86A, 1);
			bg.graphics.beginFill(0x2A2218, 1);
			bg.graphics.drawRoundRect(0, 0, w, h, 10);
			bg.graphics.endFill();
		});
		return btn;
	}

	static function textField(text:String, size:Int, color:Int, width:Float, bold:Bool):TextField {
		var tf = new TextField();
		tf.selectable = false;
		tf.mouseEnabled = false;
		tf.embedFonts = true;
		tf.multiline = false;
		tf.wordWrap = false;
		tf.width = width;
		tf.height = size + 10;
		var fmt = new TextFormat(FONT_HEB, size, color, bold);
		tf.defaultTextFormat = fmt;
		tf.text = text;
		return tf;
	}
}
