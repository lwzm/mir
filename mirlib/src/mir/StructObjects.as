package mir {
	import flash.utils.ByteArray;

	public final class StructObjects {
		private var w:int;
		private var h:int;
		private var index1:Vector.<int>;
		private var index2:Vector.<int>;

		public function StructObjects(bytes:ByteArray) {
			var i:int, j:int, n:int, idx:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			n = w * h;
			index1 = new Vector.<int>(n);
			index2 = new Vector.<int>(n);
			for (i = 0; i < h; i++) {
				for (j = 0; j < w; j++) {
					idx = w * i + j;
					index1[idx] = bytes.readUnsignedByte();
					index2[idx] = bytes.readUnsignedShort();
				}
			}
		}

		public function get width():int { return w; }
		public function get height():int { return h; }

		public function g(x:int, y:int):MirBitmapData {
			var i:int, j:int, idx:int;
			var data:MirBitmapData;
			idx = w * y + x;
			i = index1[idx];
			j = index2[idx];
			if (j) {
				data = Res.objects[i].g((j - 1).toString());
			}
			return data;
		}
	}
}