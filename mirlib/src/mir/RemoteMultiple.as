package mir {
	public final class RemoteMultiple {
		public static const dummy:Array = [null,null,null,null,null,null]; 
		public var all:Object; 
		public var urlPrefix:String; 
		
		public function RemoteMultiple(category:String, dummy:Boolean=false) {
			all = {};
			urlPrefix = Const.ASSETS_DOMAIN + category +"/";
		}
		
		public function g(name:String):Array {
			if (!all[name]) {
				prepair(name);
			}
			return all[name];
		}

		private function prepair(name:String):void {
			all[name] = dummy;
			Utils.loadMirBitmaps(urlPrefix + name, function(arr:Array):void {
				all[name] = arr;
			});
		}

	}
}