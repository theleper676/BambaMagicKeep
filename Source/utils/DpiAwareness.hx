package utils;

/**
	Declares the process DPI-aware on Windows, before lime creates the window.

	Without it Windows treats the game as a DPI-unaware program: on a monitor scaled to 150%
	it hands the game a virtual desktop (2560x1440 on a 3840x2160 screen), upscales the
	rendered frame itself - softening text and vector art - and converts mouse positions
	between the two. After a real display-mode change (utils.DisplaySettings) that conversion
	no longer matched the screen, so clicks landed away from the cursor.

	Runs from `__init__`, which hxcpp calls at startup before main(): the awareness has to be
	set before the first window exists. Per-monitor v2 where Windows 10 provides it, else the
	older system-wide call.

	The window then opens at its literal pixel size, so `windowScale()` gives the factor to
	enlarge it by to keep its usual on-screen size (see DisplaySettings.init).
**/
#if (cpp && windows)
@:cppFileCode('
#include <windows.h>
static int GetDpiForSystemSafe() {
	HMODULE user32 = GetModuleHandleW(L"user32.dll");
	if (user32) {
		typedef UINT (WINAPI *GetDpiFn)();
		GetDpiFn getDpi = (GetDpiFn)GetProcAddress(user32, "GetDpiForSystem");
		if (getDpi) return (int)getDpi();
	}
	return 96; // before Windows 10: no scale factor to read without linking gdi32
}
')
#end
class DpiAwareness {
	// No initializer: static initializers run after __init__ and would reset it.
	public static var enabled(default, null):Bool;

	static function __init__():Void {
		#if (cpp && windows)
		enabled = untyped __cpp__('([]() -> bool {
			HMODULE user32 = GetModuleHandleW(L"user32.dll");
			if (user32) {
				typedef BOOL (WINAPI *SetContextFn)(HANDLE);
				SetContextFn setContext = (SetContextFn)GetProcAddress(user32, "SetProcessDpiAwarenessContext");
				// DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2 is ((HANDLE)-4)
				if (setContext && setContext((HANDLE)-4)) return true;
			}
			return SetProcessDPIAware() != 0;
		})()');
		#end
	}

	/** The monitor's scale factor (1.5 at 150%), or 1 when the process is not DPI-aware. **/
	public static function windowScale():Float {
		#if (cpp && windows)
		if (!enabled) return 1;
		var dpi:Int = untyped __cpp__('(int)GetDpiForSystemSafe()');
		return dpi > 0 ? dpi / 96 : 1;
		#else
		return 1;
		#end
	}
}
