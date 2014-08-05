package mir {
	import flash.display.BitmapData;
	
	public final class MirBmp {
		public var x:int;
		public var y:int;
		public var bitmap:BitmapData;
		public var shadow:BitmapData;
		public function MirBmp(x_:int, y_:int, bitmap_:BitmapData, shadow_:BitmapData=null) {
			x = x_;
			y = y_;
			bitmap = bitmap_;
			shadow = shadow_;
		}
	}
}