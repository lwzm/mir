package mir {
	public final class LocalMultiple {
		public static const dummy:Array = [null,null,null,null,null,null]; 
		public var all:Object; 
		public var category:String; 
		
		public function LocalMultiple(category:String, dummy:Boolean=false) {
			all = {};
			this.category = category
		}
		
		public function g(name:String):Array {
			if (!all[name]) {
				prepair(name);
			}
			return all[name];
		}

		private function prepair(name:String):void {
//			var bytes:ByteArray = new Embed[category]["_" + name]();
//			all[name] = Utils.bytesToMirBitmaps(bytes);
		}
	}
}