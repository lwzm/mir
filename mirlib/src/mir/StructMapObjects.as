package mir {
	import flash.utils.ByteArray;

	public final class StructMapObjects extends StructMapBase {
		private var index1:Vector.<int>;
		private var index2:Vector.<int>;

		public function StructMapObjects(bytes:ByteArray) {
			var i:int, j:int, idx:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			len = w * h;
			index1 = new Vector.<int>(len);
			index2 = new Vector.<int>(len);
			for (i = 0; i < h; i++) {
				for (j = 0; j < w; j++) {
					idx = w * i + j;
					index1[idx] = bytes.readUnsignedByte();
					index2[idx] = bytes.readUnsignedShort();
				}
			}
		}

		override public function g(x:int, y:int):MirBitmapData {
			var i:int, j:int, idx:int;
			var data:MirBitmapData;
			idx = w * y + x;
			if (idx < len) {
				i = index1[idx];
				j = index2[idx];
				if (j) {
					data = Res.objects[i].g((j - 1).toString());
				}
			}
			return data;
		}
	}
}