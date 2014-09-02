package mir {
	public final class RemoteSingle {
		public static const dummy:Array = null;  // dummy 用于临时顶替显示
		public var all:Object; 
		public var urlPrefix:String; 

		public function RemoteSingle(category:String, dummy:Boolean=false) {
			all = {};
			urlPrefix = Const.ASSETS_DOMAIN + category +"/";
		}
		
		public function g(name:String):MirBitmapData {
			if (!all[name]) {
				prepair(name);
			}
			return all[name];
		}
		
		private function prepair(name:String):void {
			all[name] = dummy;
			Util.loadMirBitmap(urlPrefix + name, function(data:MirBitmapData):void {
				all[name] = data;
			});
		}
	}
}