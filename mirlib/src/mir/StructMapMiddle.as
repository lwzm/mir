package mir {
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public final class StructMapMiddle extends StructMapBase {
		private var tiles:Dictionary;

		public function StructMapMiddle(bytes:ByteArray) {
			var i:int, j:int, n:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			len = w * h;
			tiles = new Dictionary();
			for (i = 0; i < h; i++) {
				for (j = 0; j < w; j++) {
					n = bytes.readUnsignedByte();
					if (n) {  // save memory
						tiles[w * i + j] = n
					}
				}
			}
		}
		
		override public function g(x:int, y:int):MirBitmapData {
			var i:int;
			var data:MirBitmapData;
			i = tiles[w * y + x];
			if (i) {
				data = Res.tilesm.g((i - 1).toString());
			}
			return data;
		}
		
	}
}