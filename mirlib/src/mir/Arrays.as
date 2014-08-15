package mir {
	import flash.utils.Dictionary;

	public class Arrays {
		public static const dummy:Array = [null]; 
		public var all:Object; 
		public var urlPrefix:String; 
		public function Arrays(category:String, dummy:Boolean=false) {
			// dummy 用于临时顶替显示
			all = {};
			urlPrefix = Const.ASSETS_DOMAIN + category +"/";
		}

		public function g(name:String):Array {
			var arr:Array;
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