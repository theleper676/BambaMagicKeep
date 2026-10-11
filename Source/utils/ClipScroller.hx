package utils;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Rectangle;

/**
	A vertical scroll area for an item grid - the job Flash's fl.containers.ScrollPane did.

	OpenFL has no ScrollPane. The port swapped in a HaxeUI ScrollView, but the SWF stretches the
	pane symbol (a 100x100 avatar) to size with its matrix, so the view came out scaled 3-4x,
	never got a real size, and showed a slice of the grid; the inventory pane was never wired
	at all. Anything past the first rows was clipped away and looked missing from the shop.

	This leaves the content clip on its screen, clips it to the pane's rectangle with
	scrollRect, and scrolls it with the mouse wheel or a draggable bar on the right edge -
	the side the Flash pane's scrollbar sat on. One scroller per content clip; call `refresh()`
	after rebuilding the grid.
**/
class ClipScroller {
	static inline var BAR_WIDTH = 14;
	static inline var WHEEL_STEP = 26;
	static inline var MIN_THUMB = 24;

	static var scrollers:Map<DisplayObject, ClipScroller> = new Map();

	var screen:DisplayObjectContainer;
	var content:DisplayObject;
	var area:Rectangle;
	var bar:Sprite;
	var thumb:Sprite;
	var scrollY:Float = 0;
	var contentHeight:Float = 0;
	var dragOffset:Float = 0;

	/**
		The scroller for `content`, created on first use. `pane` is the clip the SWF placed for
		the ScrollPane; it is hidden, since this replaces it. `area` is the pane's rectangle in
		`screen` coordinates.
	**/
	public static function of(screen:DisplayObjectContainer, content:DisplayObject, pane:DisplayObject, area:Rectangle):ClipScroller {
		var scroller = scrollers.get(content);
		if (scroller == null) {
			scroller = new ClipScroller(screen, content, pane, area);
			scrollers.set(content, scroller);
		}
		return scroller;
	}

	function new(screen:DisplayObjectContainer, content:DisplayObject, pane:DisplayObject, area:Rectangle) {
		this.screen = screen;
		this.content = content;
		this.area = area;
		if (pane != null) pane.visible = false;
		if (content.parent != screen) screen.addChild(content);
		content.x = area.x;
		content.y = area.y;

		bar = new Sprite();
		bar.x = area.right - BAR_WIDTH;
		bar.y = area.y;
		bar.graphics.beginFill(0x5a3d1a, 0.25);
		bar.graphics.drawRoundRect(0, 0, BAR_WIDTH, area.height, BAR_WIDTH, BAR_WIDTH);
		bar.graphics.endFill();
		thumb = new Sprite();
		thumb.buttonMode = true;
		bar.addChild(thumb);
		screen.addChild(bar);

		thumb.addEventListener(MouseEvent.MOUSE_DOWN, startDrag);
		bar.addEventListener(MouseEvent.MOUSE_DOWN, jumpTo);
		screen.addEventListener(MouseEvent.MOUSE_WHEEL, onWheel);
	}

	/** Re-measures the content after the grid was rebuilt and keeps the scroll in range. **/
	public function refresh():Void {
		content.scrollRect = null;
		var bounds = content.getBounds(content);
		contentHeight = Math.max(0, bounds.bottom);
		if (content.parent != screen) screen.addChild(content);
		// The bar above the grid it scrolls.
		screen.setChildIndex(bar, screen.numChildren - 1);
		update();
	}

	function maxScroll():Float {
		return Math.max(0, contentHeight - area.height);
	}

	function update():Void {
		scrollY = Math.max(0, Math.min(scrollY, maxScroll()));
		content.scrollRect = new Rectangle(0, scrollY, area.width, area.height);
		var scrollable = maxScroll() > 0;
		bar.visible = scrollable;
		thumb.graphics.clear();
		if (scrollable) {
			var thumbHeight = Math.max(MIN_THUMB, area.height * area.height / contentHeight);
			thumb.graphics.beginFill(0x6b4a1f, 0.85);
			thumb.graphics.drawRoundRect(1, 0, BAR_WIDTH - 2, thumbHeight, BAR_WIDTH - 2, BAR_WIDTH - 2);
			thumb.graphics.endFill();
			thumb.y = (area.height - thumbHeight) * scrollY / maxScroll();
		}
	}

	function onWheel(e:MouseEvent):Void {
		if (!content.visible || content.stage == null || maxScroll() <= 0) return;
		if (!area.contains(screen.mouseX, screen.mouseY)) return;
		scrollY -= e.delta * WHEEL_STEP;
		update();
	}

	function thumbTravel():Float {
		return area.height - thumb.height;
	}

	function startDrag(e:MouseEvent):Void {
		e.stopPropagation();
		dragOffset = bar.mouseY - thumb.y;
		screen.stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		screen.stage.addEventListener(MouseEvent.MOUSE_UP, stopDrag);
	}

	function onDrag(_):Void {
		if (thumbTravel() <= 0) return;
		var y = Math.max(0, Math.min(bar.mouseY - dragOffset, thumbTravel()));
		scrollY = y / thumbTravel() * maxScroll();
		update();
	}

	function stopDrag(_):Void {
		if (screen.stage == null) return;
		screen.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
		screen.stage.removeEventListener(MouseEvent.MOUSE_UP, stopDrag);
	}

	/** A click on the track pages toward it, like the Flash scrollbar. **/
	function jumpTo(e:MouseEvent):Void {
		if (e.target != bar) return;
		scrollY += (bar.mouseY < thumb.y ? -1 : 1) * area.height * 0.9;
		update();
	}
}
