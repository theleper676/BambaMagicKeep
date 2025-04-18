package;

class BambaHelpPage {
	public var texts:Dynamic<String> ;

	public var pics:Array<String>;

	public var links:{l1:String};

	public var template:String;

	public var id:Int;

	public function new(helpPageData:{texts:{p5:String, p4:String, p3:String, p2:String, p1:String}, template:String, pics:Array<String>, links:{l1:String}, id:Int}) {
		this.texts = helpPageData.texts;
		this.pics = helpPageData.pics;
		this.links = helpPageData.links;
		this.template = helpPageData.template;
		this.id = helpPageData.id;
		/* var _loc2_:Float = Math.NaN;
		var _loc3_:Array<Dynamic> = null;
		var _loc4_:String = null;
		var _loc5_:String = null;
		var _loc6_:Array<Dynamic> = null;
		id = Std.parseFloat(param1.get("id"));
		template = param1.get("template");
		texts = [];
		_loc2_ = 1;
		
		while (_loc2_ <= 10) {
			_loc3_ = [];
			_loc4_ = "P" + _loc2_;
			if (param1.texts.hasOwnProperty(_loc4_)) {
				var texts = Reflect.field(param1.texts, _loc4_);
				_loc3_.push(_loc4_);
				_loc3_.push(texts);
				texts.push(_loc3_);
			}
			_loc2_++;
		}
		pics = [];
		_loc2_ = 1;
		while (_loc2_ <= 10) {
			_loc3_ = [];
			_loc4_ = "PIC" + _loc2_;
			if (param1.pics.hasOwnProperty(_loc4_)) {
				_loc3_.push(_loc4_);
				var pics = Reflect.getProperty(param1.pics, _loc4_);
				_loc3_.push(pics);
				pics.push(_loc3_);
			}
			_loc2_++;
		}
		links = [];
		_loc2_ = 1;
		while (_loc2_ <= 10) {
			_loc3_ = [];
			_loc4_ = "L" + _loc2_;
			if (param1.links.hasOwnProperty(_loc4_)) {
				_loc3_.push(_loc4_);
				var linksprops:String = Reflect.getProperty(param1.links, _loc4_);
				_loc5_ = linksprops;
				_loc6_ = _loc5_.split("*");
				_loc3_.push(_loc6_[0]);
				_loc3_.push(_loc6_[1]);
				links.push(_loc3_);
			}
			_loc2_++;
		} */
	}
}
