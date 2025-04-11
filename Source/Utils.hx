import haxe.xml.Access;

class Utils {
    public static inline function extractAssetElements (root:Access, nodeName:String):Array<String> {
		var _assetArray:Array<String> = [];
		for (element in root.elements) {
			if(element.elements.hasNext()) {
				if(element.name == nodeName) {
					for (value in element.elements) {
						_assetArray.push(value.innerData);
					}
				}
			} 
		}
		return _assetArray;
	}

    public static inline function extractGeneralDataElements(root:Access, nodeName:String):String {
        var _generalElement:String = "";
        for(element in root.elements) {
            for (value in element.elements) {
               if(value.name == nodeName) {
                _generalElement = value.innerData;
               }
            }
        }
        return _generalElement;
    }
}