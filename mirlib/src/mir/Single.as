package mir {
	public class Single {
		public static const dummy:Array = null;  // dummy 用于临时顶替显示
		public var all:Object; 
		public var urlPrefix:String; 

		public function Single(category:String, dummy:Boolean=false) {
			all = {};
			urlPrefix = Const.ASSETS_DOMAIN + category +"/";
		}
		
		public function g(name:String):* {
			if (!all[name]) {
				prepair(name);
			}
			return all[name];
		}
		
		public function prepair(name:String):void {
			all[name] = dummy;
			Utils.loadMirBitmap(urlPrefix + name, function(data:MirBitmapData):void {
				all[name] = data;
			});
		}
	}
}