package mir {
	import flash.utils.ByteArray;

	public final class StructMapGround extends StructMapBase {
		private var tiles:Vector.<int>;
		private var maxLen:int;

		public function StructMapGround(bytes:ByteArray) {
			var i:int, j:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			maxLen = w * h;
			tiles = new Vector.<int>(maxLen);
			for (i = 0; i < h; i += 2) {
				for (j = 0; j < w; j += 2) {
					tiles[w * i + j] = bytes.readUnsignedShort();
				}
			}
		}

		override public function g(x:int, y:int):MirBitmapData {
			var i:int, idx:int;
			var data:MirBitmapData;
			x -= x & 0x01;
			y -= y & 0x01;
			idx = w * y + x;
			i = idx < maxLen ? tiles[idx] : 0;
			if (i) {
				data = Res.tiles.g((i - 1).toString());
			}
			return data;
		}
	}
}