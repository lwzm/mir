package mir {

	public final class Multiple {
		public static const dummy:Array = [null]; 
		public var all:Object; 
		public var urlPrefix:String; 
		
		public function Multiple(category:String, dummy:Boolean=false) {
			all = {};
			urlPrefix = Const.ASSETS_DOMAIN + category +"/";
		}
		
		public function g(name:String):Array {
			if (!all[name]) {
				prepair(name);
			}
			return all[name];
		}

		public function prepair(name:String):void {
			all[name] = dummy;
			Utils.loadMirBitmaps(urlPrefix + name, function(arr:Array):void {
				all[name] = arr;
			});
		}

	}
}