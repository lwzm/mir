package mir {
	import flash.utils.ByteArray;

	public final class StructMapMask extends StructMapBase {
		private const mask1:Vector.<Boolean> = new Vector.<Boolean>();
		private const mask2:Vector.<Boolean> = new Vector.<Boolean>();
		private var maxLen:int;

		public function StructMapMask(bytes:ByteArray) {
			var mask:int;
			w = bytes.readUnsignedShort();
			h = bytes.readUnsignedShort();
			maxLen = w * h;
			while (bytes.bytesAvailable) {
				mask = bytes.readUnsignedByte();
				mask1.push(mask & 0x01);
				mask2.push(mask & 0x02);
			}
		}

		private function getMask(m:Vector.<Boolean>, x:int, y:int):Boolean {
			var idx:int, b:Boolean;
			if (x >= 0 && y >= 0) {
				idx = w * y + x;
				if (idx < maxLen) {
					b = m[idx];
				}
			}
			return b;
		}

		public function m1(x:int, y:int):Boolean {
			return getMask(mask1, x, y);
		}

		public function m2(x:int, y:int):Boolean {
			return getMask(mask2, x, y);
		}

	}
}