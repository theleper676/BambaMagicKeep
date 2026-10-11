package;

import openfl.display.*;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.net.SharedObject;
import openfl.text.TextField;
import openfl.ui.Keyboard;
import general.ButtonUpdater;
import general.Heb;

class BambaOpeningScreen extends Sprite {
	public var mc:OpeningScreen;

	var userPassSharedObject:SharedObject;

	public var currStage:Float;

	var game:BambaMain;

	

	public function new(mainGame:BambaMain) {
		super();
		game = mainGame;
		mc = new OpeningScreen();
		//ButtonUpdater.setButton(mc.enterMC, enterClicked);

		ButtonUpdater.setButton(mc.enterMC, enterClicked);
		ButtonUpdater.setButton(mc.loginMC.backMC, loginBackClicked);
		ButtonUpdater.setButton(mc.newMC, newClicked);
		ButtonUpdater.setButton(mc.loginMC.forgetPassMC, forgetPassClicked);
		ButtonUpdater.setButton(mc.forgetPassWinMC.sendMailMC, sendMailClicked);
		ButtonUpdater.setButton(mc.forgetPassWinMC.backMC, forgetBackClicked);
		addResolutionButton();
		mc.loginMC.passIT.displayAsPassword = true;
		// Must be the same dispatcher this is removed from in setFocusOnUser(), or the listener
		// is never unregistered and keeps pulling focus onto this screen for the rest of the run.
		game.stage.addEventListener(MouseEvent.CLICK, setFocusOnUser);
		mc.addEventListener(KeyboardEvent.KEY_DOWN, keyPressedDown);
		setOnStart();
		setBottomButtonsVisible(game.finishLoading);
		if (!game.finishLoading) {
			mc.loadingBarMC.flareMC.x = 800;
			mc.loadingBarMC.maskMC.width = 0;
			mc.loadingBarMC.maskMC.x = 800;
			mc.loadingBarMC.msgDT.text = "";
			mc.loadingBarMC.loaderDT.text = "";
			mc.loginMC.errorDT.text = "";
		} else {
			hideLoadingBar();
		}
		userPassSharedObject = SharedObject.getLocal("BambaUserPass743");
		if (userPassSharedObject.data.SOName != "BambaUserPass743") {
			userPassSharedObject.data.SOName = "BambaUserPass743";
			userPassSharedObject.flush();
			game.autoLogin = false;
		} else if (userPassSharedObject.data.user != null) {
			mc.loginMC.userIT.text = userPassSharedObject.data.user;
			mc.loginMC.passIT.text = userPassSharedObject.data.pass;
			if (!game.autoLogin) {}
		} else {
			game.autoLogin = false;
		}
	}

	/**
		Puts the caret in the user name field the first time the player clicks, then gets out of
		the way. Two things this has to be careful about:

		- it was registered on `game` but unregistered from `game.stage`, so it never came off.
		  Every click for the rest of the session pulled focus onto this screen's login field -
		  including clicks on the new-player screen, which is why only its first field could be
		  typed into.
		- a click that already landed on a text field is the player choosing that field, so
		  taking focus away from it would fight them. Only an unfocused click gets redirected.
	**/
	function setFocusOnUser(param1:MouseEvent):Void {
		game.stage.removeEventListener(MouseEvent.CLICK, setFocusOnUser);
		if (Std.isOfType(param1.target, TextField)) return;
		if (mc.parent == null) return;
		game.stage.focus = mc.loginMC.userIT;
	}

	function keyPressedDown(param1:KeyboardEvent):Void {
		var _loc2_:Int = 0;
		if (game.msgShown == false) {
			_loc2_ = param1.keyCode;
			switch (_loc2_) {
				case Keyboard.ENTER:
					enterGame();
			}
		}
	}

	/**
		Two buttons the original did not have: the screen-mode menu (general.ResolutionMenu), so
		the screen can be set before signing up or loading a save, and an exit that closes the
		game. Both are copies of the enter button's art. With them the bottom row holds four
		buttons, spread evenly; right to left, as the screen reads: enter, new user,
		resolution, exit.
	**/
	function addResolutionButton():Void {
		var enter = mc.enterMC;
		var resolution = general.ResolutionMenu.makeButton(new openingAssets_fla.Ok_btn_13(), game);
		var exit = general.ResolutionMenu.relabel(new openingAssets_fla.Ok_btn_13(), "יציאה", exitGameClicked);
		var row:Array<openfl.display.MovieClip> = [exit, resolution, mc.newMC, enter];
		bottomButtons = row;
		for (button in [resolution, exit]) {
			button.scaleX = enter.scaleX;
			button.scaleY = enter.scaleY;
			mc.addChild(button);
		}
		var left = 40.0;
		var right = BambaMain.DESIGN_WIDTH - 40.0;
		var gap = (right - left - enter.width * row.length) / (row.length - 1);
		for (i in 0...row.length) {
			row[i].x = Math.round(left + i * (enter.width + gap));
			row[i].y = enter.y;
		}
	}

	// The bottom row, hidden while the game's files are still loading (see hideLoadingBar).
	var bottomButtons:Array<openfl.display.MovieClip> = [];

	function setBottomButtonsVisible(visible:Bool):Void {
		for (button in bottomButtons) button.visible = visible;
	}

	function exitGameClicked():Void {
		if (game.msgShown) return;
		game.sound.playEffect("GENERAL_MENU_CLICK");
		openfl.system.System.exit(0);
	}

	public function setOnStart():Void {
		currStage = 1;
		mc.gotoAndStop("start");
	}

	/**
		Shows the credentials for a recovered account. The original mailed them; with no mail
		server there is nothing to send, so they go on the login screen instead, where the
		player can read them and type them in.
	**/
	public function showLocalCredentials(user:String, pass:String):Void {
		currStage = 2;
		mc.gotoAndStop("login");
		mc.loginMC.userIT.text = user;
		mc.loginMC.passIT.text = pass;
		Heb.setText(mc.loginMC.errorDT, "שם המשתמש והסיסמה שלך מולאו עבורך");
	}

	public function showPassSendMsg():Void {
		currStage = 2;
		mc.gotoAndStop("login");
		Heb.setText(mc.loginMC.errorDT, "שם המשתמש והסיסמה נשלחו לכתובת המייל איתה נרשמת");
	}

	function forgetBackClicked(param1:MouseEvent):Void {
		if (game.msgShown == false) {
			currStage = 2;
			mc.gotoAndStop("login");
		}
	}

	function sendMailClicked(param1:MouseEvent):Void {
		if (game.msgShown == false) {
			game.gameLoader.forgetPass(mc.forgetPassWinMC.mailIT.text);
			Heb.setText(mc.forgetPassWinMC.errorDT, "כתובת המייל בבדיקה");
		}
	}

	public function hideLoadingBar():Void {
		mc.loadingBarMC.visible = false;
		setBottomButtonsVisible(true);
	}

	function loginBackClicked(param1:MouseEvent):Void {
		if (game.msgShown == false) {
			currStage = 1;
			mc.gotoAndStop("start");
		}
	}

	function newClicked(param1:MouseEvent):Void {
		if (game.finishLoading) {
			if (game.msgShown == false) {
				game.innerCount(12);
				game.initGeneral();
				game.movie.loadAndShow();
			}
		} else {
			Heb.setText(mc.loadingBarMC.msgDT, "רגע... עוד לא סיימנו לטעון");
		}
	}

	public function saveUserPass(param1:Dynamic, param2:Dynamic):Void {
		userPassSharedObject.data.user = param1;
		userPassSharedObject.data.pass = param2;
	}

	function forgetPassClicked(param1:MouseEvent):Void {
		if (game.msgShown == false) {
			currStage = 3;
			mc.gotoAndStop("forgetPass");
		}
	}

	/**
		Opening a save file has replaced typing a user name and password, so this goes straight
		to the native Open dialog. The loginMC sub-screen with its user/pass fields and its
		"forgot password" button is no longer routed to - see enterClicked().
	**/
	function enterGame():Void {
		if (!game.didLogin) {
			game.gameLoader.loadPlayerData();
			Heb.setText(mc.loadingBarMC.msgDT, "בחר קובץ שמירה");
		} else {
			Heb.setText(mc.loadingBarMC.msgDT, "רגע... עוד לא סיימנו לטעון");
		}
	}

	function enterClicked(param1:MouseEvent):Void {
		if (game.msgShown == false) {
			trace("currStage:" + currStage);
			switch (currStage) {
				// Both stages open the file dialog now. Stage 1 no longer detours through the
				// login form, since there are no credentials left to collect, and autoLogin is
				// irrelevant once the player is choosing the save themselves.
				case 1, 2:
					enterGame();
			}
		}
	}

	public function showForgetPassErrorMsg(param1:Float):Void {
		switch (param1) {
			case 1:
				Heb.setText(mc.forgetPassWinMC.errorDT, "כתובת המייל לא נמצאה, האם זו הכתובת איתה נרשמת למשחק?");
			case 2:
				Heb.setText(mc.forgetPassWinMC.errorDT, "כתובת המייל אינה חוקית");
		}
	}

	public function showErrorMsg(param1:Float):Void {
		switch (param1) {
			case 1:
				currStage = 2;
				mc.gotoAndStop("login");
				Heb.setText(mc.loginMC.errorDT, "שם המשתמש אינו קיים");
			case 2:
				currStage = 2;
				mc.gotoAndStop("login");
				Heb.setText(mc.loginMC.errorDT, "טעית בהקשת הסיסמה. נסה שוב");
		}
	}
}
