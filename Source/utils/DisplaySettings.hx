package utils;

import lime.app.Application;
import lime.system.DisplayMode;

/**
	Screen mode choice for the main menu's resolution menu (general.ResolutionMenu): a window,
	fullscreen at the desktop resolution, or exclusive fullscreen at one of the monitor's modes.
	The choice is kept in settings.json next to the saves folder and applied again at startup.

	lime switches fullscreen to exclusive mode as soon as a display mode is set, and has no way
	back to the borderless desktop fullscreen afterwards, so "desktop" re-selects the monitor's
	own mode once any other mode has been used. That looks the same.

	The game scales itself to whatever the stage becomes (BambaMain.fitToStage), so nothing else
	needs to know which mode is in use.
**/
class DisplaySettings {
	public static inline var WINDOW = "window";
	public static inline var DESKTOP = "desktop";

	/** The game's design size: smaller modes would scale the art down. **/
	static inline var MIN_WIDTH = 1024;
	static inline var MIN_HEIGHT = 720;

	public static var current(default, null):String = WINDOW;

	// The monitor's mode before any change, for returning to the desktop resolution.
	static var desktopMode:DisplayMode;
	static var exclusiveUsed = false;

	/** Distinct resolutions the monitor supports, largest first, at their best refresh rate. **/
	public static function modes():Array<DisplayMode> {
		var display = window() != null ? window().display : null;
		if (display == null || display.supportedModes == null) return [];
		var best = new Map<String, DisplayMode>();
		for (mode in display.supportedModes) {
			if (mode.width < MIN_WIDTH || mode.height < MIN_HEIGHT) continue;
			var key = key(mode);
			var seen = best.get(key);
			if (seen == null || mode.refreshRate > seen.refreshRate) best.set(key, mode);
		}
		var list = [for (mode in best) mode];
		list.sort(function(a, b) return (b.width * b.height) - (a.width * a.height));
		return list;
	}

	public static function key(mode:DisplayMode):String {
		return mode.width + "x" + mode.height;
	}

	/** Called once at startup: remembers the desktop mode and restores the saved choice. **/
	public static function init():Void {
		var win = window();
		if (win == null) return;
		if (win.display != null) desktopMode = win.display.currentMode;
		matchRefreshRate();
		// The process is DPI-aware (DpiAwareness), so the window opened at its literal pixel
		// size; enlarge it by the display scale to keep its usual on-screen size.
		var scale = DpiAwareness.windowScale();
		if (scale > 1 && !win.fullscreen) {
			var width = Std.int(win.width * scale);
			var height = Std.int(win.height * scale);
			var bounds = win.display != null ? win.display.bounds : null;
			if (bounds != null) {
				width = Std.int(Math.min(width, bounds.width * 0.95));
				height = Std.int(Math.min(height, bounds.height * 0.9));
			}
			win.resize(width, height);
			if (bounds != null) win.move(Std.int(bounds.x + (bounds.width - width) / 2), Std.int(bounds.y + (bounds.height - height) / 2));
		}
		// First-run default: exclusive fullscreen at the monitor's native resolution. A saved
		// WINDOW/DESKTOP/mode choice from a previous session always wins over the default.
		var saved = load();
		if (saved == null && desktopMode != null) saved = key(desktopMode);
		if (saved != null && saved != WINDOW) apply(saved, false);
		else current = WINDOW;
		#if (debug && sys)
		// BAMBA_MODE_TEST="1600x1200,desktop,1920x1080": switch through these every 6 seconds,
		// to check mode changes without driving the menu.
		var test = Sys.getEnv("BAMBA_MODE_TEST");
		if (test != null && test != "") {
			var steps = test.split(",");
			var timer = new haxe.Timer(6000);
			timer.run = function() {
				if (steps.length == 0) { timer.stop(); return; }
				var step = steps.shift();
				trace("DisplaySettings test: switching to " + step);
				apply(step, false);
			};
		}
		#end
	}

	public static function apply(choice:String, persist:Bool = true):Void {
		var win = window();
		if (win == null) return;
		try {
			if (choice == WINDOW) {
				win.fullscreen = false;
			} else if (choice == DESKTOP) {
				if (exclusiveUsed && desktopMode != null) {
					if (win.fullscreen) win.fullscreen = false;
					win.displayMode = desktopMode;
				}
				win.fullscreen = true;
			} else {
				var mode = [for (m in modes()) if (key(m) == choice) m][0];
				if (mode == null) {
					trace("DisplaySettings: mode " + choice + " is not available, using the desktop resolution");
					choice = DESKTOP;
					win.fullscreen = true;
				} else {
					// Leave fullscreen before changing the mode. Changing it in place left the
					// monitor at its old resolution with the game drawing to a stale, larger
					// surface - the picture showed shifted down and cropped.
					if (win.fullscreen) win.fullscreen = false;
					win.displayMode = mode;
					exclusiveUsed = true;
					win.fullscreen = true;
				}
			}
			current = choice;
			matchRefreshRate();
			if (persist) save(choice);
		} catch (e:Dynamic) {
			trace("DisplaySettings: could not switch to " + choice + ": " + e);
		}
	}

	/**
		Runs the game at the monitor's refresh rate (60, 144, 240 Hz...). project.xml asks for
		vsync, but it does not take effect on every driver - here it ran at the 240 fps ceiling
		on a 144 Hz monitor, drawing frames that are never shown.
	**/
	static function matchRefreshRate():Void {
		var win = window();
		if (win == null || win.display == null || win.display.currentMode == null) return;
		var hz = win.display.currentMode.refreshRate;
		if (hz >= 30 && hz <= 500) {
			win.frameRate = hz;
			trace("DisplaySettings: frame rate " + hz);
		}
	}

	static function window():lime.ui.Window {
		return Application.current != null ? Application.current.window : null;
	}

	#if sys
	static function path():String {
		var base = lime.system.System.applicationStorageDirectory;
		if (base == null) return null;
		while (StringTools.endsWith(base, "/") || StringTools.endsWith(base, "\\")) base = base.substr(0, base.length - 1);
		return base + "/settings.json";
	}
	#end

	static function load():String {
		#if sys
		try {
			var file = path();
			if (file != null && sys.FileSystem.exists(file)) {
				var data:Dynamic = haxe.Json.parse(sys.io.File.getContent(file));
				if (data != null && Std.isOfType(data.screen, String)) return data.screen;
			}
		} catch (e:Dynamic) {
			trace("DisplaySettings: could not read settings (" + e + ")");
		}
		#end
		return null;
	}

	static function save(choice:String):Void {
		#if sys
		try {
			var file = path();
			if (file != null) sys.io.File.saveContent(file, haxe.Json.stringify({screen: choice}, null, "  "));
		} catch (e:Dynamic) {
			trace("DisplaySettings: could not save settings (" + e + ")");
		}
		#end
	}
}
