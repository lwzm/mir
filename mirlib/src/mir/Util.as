package mir {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	

	public final class Util {

		public static function trim(str:String):String {
			return str.replace(/^\s+/, "").replace(/\s+$/, "");
		}

		public static function len(obj:Object):int {
			var n:int;
			for (var x:* in obj)
				n++;
			return n;
		}

		public static function autoGc():void {  // for dev
			const timer:Timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				System.gc();
			});
			timer.start();
		}

		public static function delayCall(callback:Function, delay:Number):void {
			const timer:Timer = new Timer(delay, 1);
			function f(e:TimerEvent):void {
				timer.removeEventListener(TimerEvent.TIMER_COMPLETE, f);
				callback();
			}
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, f);
			timer.start();
		}

		public static function copyMirBitmapDataToBitmap(mirbmp:MirBitmapData, bmp:Bitmap, rect:Rectangle=null):void {
			var data:BitmapData;
			if (mirbmp) {
				if (rect) {
					if (!rect.width) {
						rect.width = mirbmp.width - rect.x;
					}
					if (!rect.height) {
						rect.height = mirbmp.height - rect.y;
					}
					data = new BitmapData(mirbmp.width, mirbmp.height, true, 0);
					data.copyPixels(mirbmp, rect, rect.topLeft);
				}
				bmp.bitmapData = data || mirbmp;
				bmp.x = mirbmp.x;
				bmp.y = mirbmp.y;
			} else {
				bmp.bitmapData = null;
				bmp.x = bmp.y = 0;
			}
		}

		public static function bytesToMirBitmapData(bytes:ByteArray):MirBitmapData {
			var data:MirBitmapData;
			var iw:int, ih:int, color:uint;
			const w:int = bytes.readShort();
			const h:int = bytes.readShort();
			const x:int = bytes.readShort();
			const y:int = bytes.readShort();
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
			while (bytes.bytesAvailable > 1) {
				bmps.push(bytesToMirBitmapData(bytes));
			}
			return bmps;
		}

		public static function loadMirBitmap(url:String, callback:Function):void {
			loadBinary(url, function(bytes:ByteArray):void {
				callback(bytesToMirBitmapData(bytes));
			}, true);
		}

		public static function loadMirBitmaps(url:String, callback:Function):void {
			loadBinary(url, function(bytes:ByteArray):void {
				callback(bytesToMirBitmaps(bytes));
			}, true);
		}


		private static function load(url:String, format:String, callback:Function):void {
			const loader:URLLoader = new URLLoader(new URLRequest(url));
			loader.dataFormat = format;
			function f(e:Event):void {
				loader.removeEventListener(Event.COMPLETE, f);  // trace(loader.hasEventListener(Event.COMPLETE));
				callback(loader.data);
			}
			loader.addEventListener(Event.COMPLETE, f);
			loader.addEventListener(IOErrorEvent.IO_ERROR, loadOnError);
		}

		private static function loadOnError(e:ErrorEvent):void {
			trace(e);
			(e.target as URLLoader).removeEventListener(IOErrorEvent.IO_ERROR, loadOnError);
		}

		public static function loadString(url:String, callback:Function):void {
			load(url, URLLoaderDataFormat.TEXT, callback);
		}

		public static function loadBinary(url:String, callback:Function, deflated:Boolean=false):void {
			const bytes:ByteArray = new ByteArray();
			load(url, URLLoaderDataFormat.BINARY, function(bytes:ByteArray):void {
				if (deflated) {
					bytes.inflate();
				}
				callback(bytes);
			});
		}

	}
}