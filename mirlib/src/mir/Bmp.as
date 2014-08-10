package mir {
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	
	public final class Bmp {
		public var x:int;
		public var y:int;
		public var bitmap:BitmapData;
		public var shadow:BitmapData;
		public var blendMode:String;
		public function Bmp(x_:int, y_:int, bitmap_:BitmapData, shadow_:BitmapData, blendMode_:String=BlendMode.NORMAL) {
			x = x_;
			y = y_;
			bitmap = bitmap_;
			shadow = shadow_;
			blendMode = blendMode_;
		}
	}
}