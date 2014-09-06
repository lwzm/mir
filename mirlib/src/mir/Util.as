package mir {
	import flash.display.Bitmap;
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
			var timer:Timer = new Timer(3000);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				System.gc();
			});
			timer.start();
		}

		public static function range(start:Number, stop:Number, step:Number=1):Array {
			var arr:Array = [];
			if (start < stop) {
				stop += 0.01;
				while (start < stop) {
					arr.push(start);
					start += step;
				}
			} else {
				stop -= 0.01;
				while (start > stop) {
					arr.push(start);
					start += step;
				}
			}
			return arr;
		}

		public static function steps(start:Number, stop:Number, n:Number):Array {
			var delta:Number = (stop - start) / n;
			return range(start + delta, stop, delta).map(round);
		}
		
		private static function round(item:Number, index:int, array:Array):int {
			var n:int = Math.ceil(item);
			return n;
		}

		public static function copyMirBitmapDataToBitmap(mirbmp:MirBitmapData, bmp:Bitmap):void {
			if (mirbmp) {
				bmp.bitmapData = mirbmp;
				bmp.x = mirbmp.x;
				bmp.y = mirbmp.y;
			} else {
				bmp.bitmapData = null;
			}
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
			while (bytes.bytesAvailable > 1) {
				bmps.push(bytesToMirBitmapData(bytes));
			}
			return bmps;
		}

		public static function loadMirBitmap(url:String, callback:Function):void {
			loadDeflatedBinary(url, function(bytes:ByteArray):void {
				callback(bytesToMirBitmapData(bytes));
			});
		}

		public static function loadMirBitmaps(url:String, callback:Function):void {
			loadDeflatedBinary(url, function(bytes:ByteArray):void {
				callback(bytesToMirBitmaps(bytes));
			});
		}


		private static function load(url:String, format:String, callback:Function):void {
			var loader:URLLoader = new URLLoader(new URLRequest(url));
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

		public static function loadBinary(url:String, callback:Function):void {
			var bytes:ByteArray = new ByteArray();
			load(url, URLLoaderDataFormat.BINARY, function(bytes:ByteArray):void {
				callback(bytes);
			});
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