package mir {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public class Foo {
		
		public function Foo() {
		}
		
		public static function extract_bmp(bytes:ByteArray, need_shadow:Boolean=false):MirBmp {
			var w:int, h:int, x:int, y:int;
			var iw:int, ih:int, color:uint;
			var bitmap:BitmapData;
			var shadow:BitmapData;
			
			w = bytes.readShort();
			h = bytes.readShort();
			x = bytes.readShort();
			y = bytes.readShort();
			bitmap = new BitmapData(w, h, true, 0);
			shadow = need_shadow ? new BitmapData(w, h, true, 0) : null;
			
			for (ih = h - 1; ih >= 0; ih--) {
				for (iw = 0; iw < w; iw++) {
					color = Const.PALLET[bytes.readUnsignedByte()];
					if (color) {
						bitmap.setPixel32(iw, ih, color);
						need_shadow ? shadow.setPixel32(iw, ih, color - 0x80000000) : null;
					}
				}
			}
			
			return new MirBmp(x, y, bitmap, shadow);
		}
	}
}