package mir {
	import flash.display.Bitmap;
	import flash.utils.ByteArray;

	public final class MapMiddle extends MapBase {
		public function MapMiddle() {
			super("middle.bin");
		}

		override protected function initStruct(bytes:ByteArray):void {
			struct = new StructMapMiddle(bytes);
		}

		override protected function initChildren():void {
			var bmp:Bitmap;
			var w:int, h:int;
			for (h = Const.TILE_EDGE; h < Const.TILE_Y; h++) {
				for (w = Const.TILE_EDGE; w < Const.TILE_X; w++) {
					bmp = new Bitmap();
					bmp.x = Const.TILE_W * (w - 1) + 7;
					bmp.y = Const.TILE_H * (h - 1) - 44;
					addChild(bmp);
				}
			}
		}
		
		override protected function update(active:Boolean=false):void {
			var w:int, h:int, i:int;
			if (active) {
				x = Const.MAP_OFFSET_X;
				y = Const.MAP_OFFSET_Y;
			}
			for (h = Const.TILE_EDGE; h < Const.TILE_Y; h++) {
				for (w = Const.TILE_EDGE; w < Const.TILE_X; w++) {
					setTile(getChildAt(i++) as Bitmap, w + mX, h + mY, active);
				}
			}
		}

		private function setTile(bmp:Bitmap, x:int, y:int, active:Boolean):void {
			var s:String;
			var data:MirBitmapData;
			if (x >= 0 && y >= 0) {
				if (!active && bmp.bitmapData) return;
				data = struct.g(x, y);
				bmp.bitmapData = data;
			}
		}
	}
}