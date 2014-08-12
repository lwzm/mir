package mir {
	public class Arrays {
		public var all:Object; 
		public var urlPrefix:String; 
		public function Arrays(category:String, dummy:Boolean=false) {
			// dummy 用于临时顶替显示
			all = {};
			urlPrefix = Const.ASSETS_DOMAIN + category +"/";
		}

		public function ggg(role:uint, sex:uint, motion:uint, direction:uint, id:uint):MirBitmapData {
			sex < 2;
			motion < 11;
			direction < 8;
			var s:String = (role * 22 + sex * 11 + motion).toString() + direction.toString(16);
			trace(s);
			return gg(s, id);
		}

		public function gg(name:String, id:uint):MirBitmapData {
			var arr:Array = g(name);
			return arr ? arr[id % arr.length] as MirBitmapData : null;
		}

		public function g(name:String):Array {
			var arr:Array;
			arr = all[name];
			if (!arr) {
				prepair(name);
			}
			return arr;
		}

		public function prepair(name:String):void {
			Utils.loadMirBitmaps(urlPrefix + name, function(arr:Array):void {
				all[name] = arr;
			});
		}

	}
}