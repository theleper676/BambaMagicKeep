package general;

import openfl.display.Shape;
import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;
import utils.DisplaySettings;

/**
	The main menu's screen-mode picker: a window, fullscreen at the desktop resolution, or one
	of the monitor's resolutions (utils.DisplaySettings). Drawn in code - the menu art has no
	such screen - in the colours of the menu's own buttons. It holds game.msgShown while open,
	the same way MsgBox does, so the menu underneath ignores clicks.
**/
class ResolutionMenu extends Sprite {
	static inline var PANEL_WIDTH = 420;
	static inline var ROW_HEIGHT = 34;
	static inline var MAX_ROWS = 10;

	static inline var TEAL = 0x123F47;
	static inline var TEAL_HOVER = 0x1E5A63;
	static inline var CREAM = 0xF3E7C1;
	static inline var GOLD = 0xD9B864;

	var game:BambaMain;
	var onClose:Void->Void;

	/**
		A "רזולוציה" button that opens this menu, made from a copy of one of the game's button
		clips (see relabel). Used on the opening screen and the main menu; the caller scales and
		places it.
	**/
	public static function makeButton(button:openfl.display.MovieClip, game:BambaMain):openfl.display.MovieClip {
		return relabel(button, "רזולוציה", function() {
			if (!game.msgShown) {
				game.sound.playEffect("GENERAL_MENU_CLICK");
				open(game);
			}
		});
	}

	/**
		Gives a copy of one of the game's button clips a new label and action: the art's
		baked-in static label is hidden and a text label laid over it, centred on the art.
	**/
	public static function relabel(button:openfl.display.MovieClip, text:String, onClick:Void->Void):openfl.display.MovieClip {
		ButtonUpdater.setButton(button, function(_) onClick());
		hideStaticLabel(button);
		button.mouseChildren = false;

		var bounds = button.getBounds(button);
		var field = new TextField();
		field.embedFonts = true;
		field.selectable = false;
		field.mouseEnabled = false;
		// Choco at 28px, white: what the art's own static labels use (font "Choco", 560 twips).
		field.defaultTextFormat = new TextFormat("Choco", 28, 0xFFFFFF, null, null, null, null, null, TextFormatAlign.CENTER);
		field.width = bounds.width;
		field.height = 40;
		Heb.setText(field, text);
		field.x = bounds.x;
		// +8: line up with the art's own labels, whose baseline sits a little below centre.
		field.y = bounds.y + (bounds.height - field.height) / 2 + 8;
		button.addChild(field);

		// The art's glow sits on its label, which is hidden here, so give the new label the
		// same GlowFilter: pale yellow, soft at rest and wide on hover (frames 1 and 2).
		field.filters = [new openfl.filters.GlowFilter(0xFFFFCC, 1, 7, 7, 1, 2)];
		// The hover frame re-creates the art's label; hide it again after each state change.
		button.addEventListener(MouseEvent.ROLL_OVER, function(_) {
			hideStaticLabel(button);
			field.filters = [new openfl.filters.GlowFilter(0xFFFFCC, 1, 67, 14, 1.796875, 2)];
		});
		button.addEventListener(MouseEvent.ROLL_OUT, function(_) {
			hideStaticLabel(button);
			field.filters = [new openfl.filters.GlowFilter(0xFFFFCC, 1, 7, 7, 1, 2)];
		});
		return button;
	}

	static function hideStaticLabel(container:openfl.display.DisplayObjectContainer):Void {
		for (i in 0...container.numChildren) {
			var child = container.getChildAt(i);
			if (Std.isOfType(child, openfl.text.StaticText)) {
				child.visible = false;
			} else if (Std.isOfType(child, openfl.display.DisplayObjectContainer) && !Std.isOfType(child, TextField)) {
				hideStaticLabel(cast child);
			}
		}
	}

	public static function open(game:BambaMain, onClose:Void->Void = null):Void {
		var menu = new ResolutionMenu(game, onClose);
		game.addChild(menu);
		game.msgShown = true;
	}

	function new(game:BambaMain, onClose:Void->Void) {
		super();
		this.game = game;
		this.onClose = onClose;
		build();
	}

	function build():Void {
		while (numChildren > 0) removeChildAt(0);

		// Dim the whole game area and swallow clicks outside the panel.
		var shade = new Sprite();
		shade.graphics.beginFill(0x000000, 0.55);
		shade.graphics.drawRect(0, 0, BambaMain.DESIGN_WIDTH, BambaMain.DESIGN_HEIGHT);
		shade.graphics.endFill();
		addChild(shade);

		var options:Array<{label:String, choice:String, hebrew:Bool}> = [
			{label: "חלון", choice: DisplaySettings.WINDOW, hebrew: true},
			{label: "מסך מלא - רזולוציית שולחן העבודה", choice: DisplaySettings.DESKTOP, hebrew: true},
		];
		for (mode in DisplaySettings.modes()) {
			if (options.length >= MAX_ROWS) break;
			options.push({label: mode.width + " × " + mode.height, choice: DisplaySettings.key(mode), hebrew: false});
		}

		var top = 64;
		var panelHeight = top + options.length * (ROW_HEIGHT + 6) + 64;
		var panel = new Sprite();
		panel.graphics.lineStyle(3, GOLD);
		panel.graphics.beginFill(0x0B2A30, 0.97);
		panel.graphics.drawRoundRect(0, 0, PANEL_WIDTH, panelHeight, 28, 28);
		panel.graphics.endFill();
		panel.x = Math.round((BambaMain.DESIGN_WIDTH - PANEL_WIDTH) / 2);
		panel.y = Math.round((BambaMain.DESIGN_HEIGHT - panelHeight) / 2);
		addChild(panel);

		var title = label("רזולוציית מסך", 26, CREAM, true, PANEL_WIDTH);
		title.y = 16;
		panel.addChild(title);

		var y = top;
		for (option in options) {
			var row = button(option.label, option.hebrew, PANEL_WIDTH - 60, ROW_HEIGHT, option.choice == DisplaySettings.current);
			row.x = 30;
			row.y = y;
			var choice = option.choice;
			row.addEventListener(MouseEvent.CLICK, function(_) {
				game.sound.playEffect("GENERAL_MENU_CLICK");
				DisplaySettings.apply(choice);
				build();
			});
			panel.addChild(row);
			y += ROW_HEIGHT + 6;
		}

		var close = button("סגור", true, 140, 38, false);
		close.x = Math.round((PANEL_WIDTH - 140) / 2);
		close.y = y + 12;
		close.addEventListener(MouseEvent.CLICK, function(_) {
			game.sound.playEffect("GENERAL_MENU_CLICK");
			if (parent != null) parent.removeChild(this);
			game.msgShown = false;
			if (onClose != null) onClose();
		});
		panel.addChild(close);
	}

	function button(text:String, hebrew:Bool, width:Int, height:Int, selected:Bool):Sprite {
		var sprite = new Sprite();
		sprite.buttonMode = true;
		sprite.mouseChildren = false;
		var face = new Shape();
		sprite.addChild(face);
		function paint(hover:Bool) {
			face.graphics.clear();
			face.graphics.lineStyle(2, selected ? GOLD : CREAM, selected ? 1 : 0.8);
			face.graphics.beginFill(hover || selected ? TEAL_HOVER : TEAL);
			face.graphics.drawRoundRect(0, 0, width, height, height, height);
			face.graphics.endFill();
		}
		paint(false);
		sprite.addEventListener(MouseEvent.ROLL_OVER, function(_) paint(true));
		sprite.addEventListener(MouseEvent.ROLL_OUT, function(_) paint(false));

		var field = label(text, 18, selected ? GOLD : 0xFFFFFF, hebrew, width);
		field.y = Math.round((height - field.height) / 2);
		sprite.addChild(field);
		return sprite;
	}

	function label(text:String, size:Int, color:Int, hebrew:Bool, width:Int):TextField {
		var field = new TextField();
		field.embedFonts = true;
		field.selectable = false;
		field.mouseEnabled = false;
		field.defaultTextFormat = new TextFormat("Arial Bold", size, color, null, null, null, null, null, TextFormatAlign.CENTER);
		field.autoSize = TextFieldAutoSize.NONE;
		field.width = width;
		field.height = size + 10;
		if (hebrew) Heb.setText(field, text) else field.text = text;
		return field;
	}
}
