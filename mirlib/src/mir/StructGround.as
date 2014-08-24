package mir {
	import flash.utils.ByteArray;

	public final class StructGround {
		private var w:int;
		private var h:int;
		private var tiles:Vector.<int>;

		public function StructGround(bytes:ByteArray) {
			var i:int, j:int, n:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			n = w * h;
			tiles = new Vector.<int>(n);
			for (i = 0; i < h; i += 2) {
				for (j = 0; j < w; j += 2) {
					tiles[w * i + j] = bytes.readUnsignedShort();
				}
			}
		}

		public function get width():int { return w; }
		public function get height():int { return h; }

		public function g(x:int, y:int):MirBitmapData {
			var i:int;
			var data:MirBitmapData;
			x -= x % 2;
			y -= y % 2;
			i = tiles[w * y + x];
			if (i) {
				data = Res.tiles.g((i - 1).toString());
			}
			return data;
		}
	}
}