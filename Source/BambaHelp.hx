package;

import help.EmptyCard;
import motion.Actuate;
import haxe.Constraints.Function;
import openfl.display.*;
import openfl.events.MouseEvent;
import openfl.net.SharedObject;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import general.Heb;
import general.MsgBox;
import haxe.ui.components.CheckBox;

class BambaHelp {
	public var tutorialSharedObject:SharedObject;

	public var doShowTutorial:Bool;

	var game:BambaMain;

	var emptyCardMC:EmptyCard;

	var mc:Dynamic;

	/**
		AS3 bolted `linkId` straight onto each link clip at runtime. hxcpp cannot add fields to a
		typed class, so the mapping lives here instead, keyed by the clip itself - same fix as
		`BambaCharacterBuildScreen.orderCodes`.
	**/
	var linkIds:Map<MovieClip, Float> = new Map();

	/** HaxeUI checkbox built for each help template, keyed by the template clip - see dontShowCheckBox(). **/
	var dontShowBoxes:Map<DisplayObject, CheckBox> = new Map();

	public var currTutorialCode:Float;

	public function new(game:BambaMain) {
		this.game = game;
		tutorialSharedObject = SharedObject.getLocal("Bamba_Tutorial");
		if (tutorialSharedObject.data.tutorial == null) {
			currTutorialCode = 0;
			doShowTutorial = true;
		} else {
			currTutorialCode = tutorialSharedObject.data.tutorial[Std.int(tutorialSharedObject.data.tutorial.length) - 1];
			doShowTutorial = tutorialSharedObject.data.doShowTutorial;
		}
	}
 
	public function showTutorial(tutorialCode:Float):Bool {
		var shown = false;
		if (tutorialSharedObject.data.tutorial == null) {
			if (tutorialCode != 5) {
				currTutorialCode = tutorialCode;
				tutorialSharedObject.data.tutorial = [tutorialCode];
				tutorialSharedObject.data.doShowTutorial = true;
				doShowTutorial = true;
				tutorialSharedObject.flush();
				shown = true;
				showPage(tutorialCode, true);
			}
		} else if (doShowTutorial) {
			var seen:Array<Dynamic> = tutorialSharedObject.data.tutorial;
			if (seen.indexOf(tutorialCode) == -1 && tutorialCode == seen[seen.length - 1] + 1) {
				seen.push(tutorialCode);
				currTutorialCode = tutorialCode;
				tutorialSharedObject.flush();
				shown = true;
				showPage(tutorialCode, true);
			}
		}
		return shown;
	}

	public function finishTutorial():Void {
		currTutorialCode = 0;
		tutorialSharedObject.data.tutorial.push(currTutorialCode);
		tutorialSharedObject.data.doShowTutorial = false;
		doShowTutorial = false;
		tutorialSharedObject.flush();
	}

	function linkClicked(event:MouseEvent):Void {
		game.sound.playEffect("GENERAL_MENU_CLICK");
		if (currTutorialCode != 0) {
			var dontShowCB = dontShowBoxes.get(cast mc);
			if (dontShowCB != null && dontShowCB.selected) {
				currTutorialCode = 0;
				tutorialSharedObject.data.doShowTutorial = false;
				doShowTutorial = false;
				tutorialSharedObject.flush();
				closePage();
				return;
			}
		}
		var clickedTarget:Dynamic = event.currentTarget;
		var linkId = Std.isOfType(clickedTarget, MovieClip) ? linkIds.get(cast clickedTarget) : null;
		if (linkId != null && linkId != 0) {
			showPage(linkId);
		} else {
			closePage();
		}
	}

	function closePage():Void {
		game.msgShown = false;
		game.removeChild(mc);
		if (game.contains(emptyCardMC)) {
			game.removeChild(emptyCardMC);
		}
	}

	/**
		Shows help page `pageId`. `isTutorial` pages fade in slowly over the current screen;
		pages opened from the help button sit on an empty card instead.
	**/
	public function showPage(pageId:Float, isTutorial:Bool = false):Void {
		var page = game.gameData.getCatalogHelpPage(pageId);
		if (page == null) {
			MsgBox.show("מסך עזרה לא נמצא, קוד מסך:" + pageId);
			return;
		}
		// BambaAssets' help0N fields are the symbol instances themselves (populated once by
		// defineAsset at load time), not factory functions - the AS3 original looked up a
		// Class by name and `new`'d it; there's no class reference to instantiate here, so
		// the looked-up instance is reused directly.
		var template:Dynamic = Reflect.field(BambaAssets, page.template);
		if (emptyCardMC == null) {
			emptyCardMC = new EmptyCard();
		}
		if (!isTutorial) {
			game.addChild(emptyCardMC);
			game.centerScreen(emptyCardMC);
		}
		var previousPage:Dynamic = mc;
		if (mc != null && Std.isOfType(mc, DisplayObject)) {
			(cast mc : DisplayObject).alpha = 0;
		}
		mc = template;
		game.addChild(mc);
		if (Std.isOfType(mc, DisplayObject)) {
			(cast mc : DisplayObject).alpha = 0;
		}
		game.centerScreen(mc);
		var dontShowCB = dontShowCheckBox(cast mc);
		if (dontShowCB != null) dontShowCB.selected = false;
		if (previousPage != null && previousPage != mc && game.contains(previousPage)) {
			game.removeChild(previousPage);
		}
		game.msgShown = true;

		for (text in page.texts) {
			var textField:Dynamic = Reflect.field(mc, text[0]);
			if (textField != null) Heb.setText(textField, text[1]);
		}

		for (pic in page.pics) {
			// AS3 fetched these by URL relative to the page; natively that path doesn't exist and
			// the unhandled IOError crashed the game. They ship as embedded assets under the
			// renamed "assets/" root (project.xml), so read them from the asset library instead.
			var picId = "assets/" + pic[1];
			var picHolder:Dynamic = Reflect.field(mc, pic[0]);
			if (picHolder != null && Assets.exists(picId, AssetType.IMAGE)) {
				// Templates are reused, so drop the picture a previous showing left behind.
				var holder:DisplayObjectContainer = cast picHolder;
				for (i in 0...holder.numChildren) {
					var child = holder.getChildAt(holder.numChildren - 1 - i);
					if (Std.isOfType(child, Bitmap)) holder.removeChild(child);
				}
				var picBitmap = new Bitmap(Assets.getBitmapData(picId));
				picBitmap.smoothing = true;
				holder.addChild(picBitmap);
			} else {
				trace("help picture missing: " + picId);
			}
		}

		for (link in page.links) {
			var linkClip:Dynamic = Reflect.field(mc, link[0]);
			if (link[2] != null) {
				var linkText:Dynamic = linkClip != null ? Reflect.field(linkClip, "DT") : null;
				if (linkText != null) Heb.setText(linkText, link[2]);
			}
			if (linkClip != null && Std.isOfType(linkClip, MovieClip)) {
				var linkMC:MovieClip = cast linkClip;
				linkIds.set(linkMC, link[1]);
				linkMC.addEventListener(MouseEvent.CLICK, linkClicked);
				linkMC.buttonMode = true;
				linkMC.tabEnabled = false;
				linkMC.mouseChildren = false;
			}
		}

		if (isTutorial) {
			Actuate.tween(mc, 1.5, {alpha: 1}).delay(1.2);
		} else {
			Actuate.tween(mc, 0.5, {alpha: 1});
		}
	}

	/**
		The "don't show again" box was a Flash `fl.controls.CheckBox` component. Its generated
		class has none of the component's code, so the SWF clip is only a placeholder - and one
		that loops through all its skins. As with the new-player birthdate pickers
		(BambaNewPlayerScreen.buildDateDropDown), the placeholder is measured, removed and replaced
		by a HaxeUI CheckBox in the same spot. Help templates are reused, so this runs once each.
	**/
	function dontShowCheckBox(template:DisplayObject):CheckBox {
		if (dontShowBoxes.exists(template)) return dontShowBoxes.get(template);
		if (!Std.isOfType(template, DisplayObjectContainer)) return null;
		var container:DisplayObjectContainer = cast template;
		var placeholder = container.getChildByName("dontShowCB");
		if (placeholder == null) return null;
		var checkBox = new CheckBox();
		checkBox.left = placeholder.x;
		checkBox.top = placeholder.y;
		container.addChildAt(checkBox, container.getChildIndex(placeholder));
		container.removeChild(placeholder);
		dontShowBoxes.set(template, checkBox);
		return checkBox;
	}

	public function resetTutorial():Void {
		currTutorialCode = 0;
		doShowTutorial = true;
		tutorialSharedObject.clear();
	}
}
