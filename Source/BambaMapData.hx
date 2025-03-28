package;

class BambaMapData {
	var areas:Array<Dynamic>;

	var dungeons:Array<Dynamic>;

	public function new(param1:Xml) {
		var _loc2_:Int;
		var _loc3_:Array<Dynamic>;
		var _loc4_:Array<Dynamic>;
		var _loc5_:Array<Dynamic>;
		var _loc6_:Array<Dynamic>;
      _loc3_ = param1.get("areas").split("*");
     
		//_loc3_ = param1.areas.split("*");
		areas = [];
		_loc2_ = 0;
		while (_loc2_ < _loc3_.length) {
			_loc5_ = _loc3_[_loc2_].split(",");
			areas.push(_loc5_);
			_loc2_++;
		}
      _loc4_ = param1.get("dungeons").split("*");
		//_loc4_ = param1.dungeons.split("*");
		dungeons = [];
		_loc2_ = 0;
		while (_loc2_ < _loc4_.length) {
			_loc6_ = _loc4_[_loc2_].split(",");
			dungeons.push(_loc6_);
			_loc2_++;
		}
	}
}
