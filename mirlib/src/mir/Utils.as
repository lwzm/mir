package mir {
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import org.flexunit.asserts.assertFalse;
	

	public class Utils {

		public static function loadMirBmp(url:String, callback:Function, need_shadow:Boolean=false):void {
			loadAsset(url, function(bytes:ByteArray):void {
				callback(extractMirBmp(bytes, need_shadow));
				bytes.bytesAvailable == 0;  // just warning
			});
		}

		public static function loadMirBmps(url:String, arr:Array, need_shadow:Boolean=false, callback:Function=null):void {
			loadAsset(url, function(bytes:ByteArray):void {
				while (bytes.bytesAvailable) {
					arr.push(extractMirBmp(bytes, need_shadow));
				}
				callback ? callback() : null;
			});
		}

		public static function loadAsset(url:String, callback:Function):void {
			var stream:URLStream = new URLStream();
			var bytes:ByteArray = new ByteArray();
			stream.load(new URLRequest(url));
			stream.addEventListener(Event.COMPLETE, function(e:Event):void {
				stream.readBytes(bytes);
				bytes.inflate();
				callback(bytes);
			})
		}

		public static function extractMirBmp(bytes:ByteArray, need_shadow:Boolean=false):MirBmp {
			var w:int, h:int, x:int, y:int;
			var iw:int, ih:int, color:uint;
			var bitmap:BitmapData;
			var shadow:BitmapData;
			
			w = bytes.readShort();
			h = bytes.readShort();
			x = bytes.readShort();
			y = bytes.readShort();

			if (w && h) {
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
			}

			return new MirBmp(x, y, bitmap, shadow);
		}
	}
}