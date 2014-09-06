package mir {
	import flash.utils.ByteArray;

	public final class StructMapMiddle extends StructMapBase {
		private var tiles:Object;

		public function StructMapMiddle(bytes:ByteArray) {
			var idx:int, i:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			tiles = {};
			while (bytes.bytesAvailable > 4) {
				idx = bytes.readUnsignedInt();
				i = bytes.readUnsignedByte();
				tiles[idx] = i;
			}
		}
		
		override public function g(x:int, y:int):MirBitmapData {
			var i:int, idx:int;
			var data:MirBitmapData;
			if (x >= 0 && y >= 0) {
				idx = w * y + x;
				i = tiles[idx];
				if (i) {
					data = Res.tilesm.g((i - 1).toString());
				}
			}
			return data;
		}
	}
}