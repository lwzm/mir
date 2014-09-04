package mir {
	import flash.sampler.getSize;
	import flash.utils.ByteArray;

	public final class StructMapObjects extends StructMapBase {
		private var index1:Object;
		private var index2:Object;

		public function StructMapObjects(bytes:ByteArray) {
			var idx:int, i:int, j:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			index1 = {};
			index2 = {};
			while (bytes.bytesAvailable > 6) {
				idx = bytes.readUnsignedInt();
				i = bytes.readUnsignedByte();
				j = bytes.readUnsignedShort();
				index1[idx] = i;
				index2[idx] = j;
			}
//			trace(getSize(index1))
//			trace(getSize(index2))
//			trace(Util.len(index2))
		}

		override public function g(x:int, y:int):MirBitmapData {
			var i:int, idx:int;
			var data:MirBitmapData;
			idx = w * y + x;
			i = index2[idx];
			if (i) {
				data = Res.objects[index1[idx]].g((i - 1).toString());
			}
			return data;
		}
	}
}