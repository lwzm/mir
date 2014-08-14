package mir {
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.utils.ByteArray;
	
	import org.flexunit.asserts.assertFalse;
	

	public class Utils {

		public static function trim(str:String):String {
			return str.replace(/^\s+/, "").replace(/\s+$/, "");
		}

		public static function bytesToMirBitmapData(bytes:ByteArray):MirBitmapData {
			var data:MirBitmapData;
			var w:int, h:int, x:int, y:int;
			var iw:int, ih:int, color:uint;
			w = bytes.readShort();
			h = bytes.readShort();
			x = bytes.readShort();
			y = bytes.readShort();
			if (w && h) {
				data = new MirBitmapData(w, h, x, y);
				for (ih = h - 1; ih >= 0; ih--) {
					for (iw = 0; iw < w; iw++) {
						color = Const.PALLET[bytes.readUnsignedByte()];
						data.setPixel32(iw, ih, color);
					}
				}
			}
			return data;
		}

		public static function bytesToMirBitmaps(bytes:ByteArray):Array {
			const bmps:Array = [];
			var flag:uint;
			while (bytes.bytesAvailable > 1) {
				bmps.push(bytesToMirBitmapData(bytes));
			}
			flag = bytes.bytesAvailable ? bytes.readUnsignedByte() : 0x00;
			bmps.blendMode = flag && 0x01 ? BlendMode.ADD : BlendMode.NORMAL;
			return bmps;
		}

		public static function loadMirBitmaps(url:String, callback:Function):void {
			loadDeflatedBinary(url, function(bytes:ByteArray):void {
				callback(bytesToMirBitmaps(bytes));
			});
		}


		private static function load(url:String, format:String, callback:Function):void {
			var loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.dataFormat = format;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				loader.removeEventListener(Event.COMPLETE, arguments.callee);  // then, loader.hasEventListener(Event.COMPLETE) == false;
				callback(loader.data);
			});
		}

		public static function loadString(url:String, callback:Function):void {
			load(url, URLLoaderDataFormat.TEXT, callback);
		}

		public static function loadDeflatedBinary(url:String, callback:Function):void {
			var bytes:ByteArray = new ByteArray();
			load(url, URLLoaderDataFormat.BINARY, function(bytes:ByteArray):void {
				bytes.inflate();
				callback(bytes);
			});
		}
	}
}