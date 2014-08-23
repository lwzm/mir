package mir {
	import flash.utils.ByteArray;

	public final class StructGround {
		public var w:int;
		public var h:int;
		public var tiles:Vector.<int>;

		public function StructGround(bytes:ByteArray) {
			var i:int, j:int, n:int;
			w = bytes.readShort();
			h = bytes.readShort();
			n = w * h;
			tiles = new Vector.<int>(n);
			for (i = 0; i < h; i += 2) {
				for (j = 0; j < w; j += 2) {
					tiles[w * i + j] = bytes.readShort();
				}
			}
		}

		public function g(x:int, y:int):String {
			x -= x % 2;
			y -= y % 2;
			var i:int = tiles[w * y + x];
			return i ? (i - 1).toString() : null;
		}
	}
}