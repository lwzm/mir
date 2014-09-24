package mir {
	import flash.display.BitmapData;
	
	public final class MirBitmapData extends BitmapData {
		public var x:int;
		public var y:int;
		public function MirBitmapData(width:int, height:int, x:int, y:int) {
			super(width, height, true, 0);
			this.x = x;
			this.y = y;
		}
	}
}