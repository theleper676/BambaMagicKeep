package utils;

import openfl.events.Event;
import openfl.display.DisplayObject;
import haxe.ui.core.Component;

class DisplayClipComponent extends Component {
    public var displayObject:DisplayObject;
    public function new(displayObject:DisplayObject) {
        super();
        this.displayObject = displayObject;
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    override function onAddedToStage(e:Event):Void {
        this.addChild(displayObject);
    }
}