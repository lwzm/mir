package {
	import flash.utils.ByteArray;

	public final class StructGround {
		public var w:int;
		public var h:int;
		public var tiles:Vector.<int>;

		public function StructGround(bytes:ByteArray) {
			var i:int, n:int;
			w = bytes.readShort();
			h = bytes.readShort();
			n = w * h / 4;
			tiles = new Vector.<int>(n);
			do {
				tiles[i++] = bytes.readShort();
			} while (i < n);
//			bytes.bytesAvailable == 0;
		}

		public function g(x:int, y:int):String {
			return (tiles[w * y + x] - 1).toString();
		}
	}
}