package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mir.Const;
	import mir.Filters;
	import mir.MirBitmapData;
	import mir.StructObjects;
	import mir.Utils;

	public final class MapObjects extends Sprite {

		public var struct:StructObjects;

		private var objs:Vector.<Bitmap>;
		private var stepsX:Array;
		private var stepsY:Array;
		private var mX:int;
		private var mY:int;
		private var mX_:int;
		private var mY_:int;
		private var idx:int;
		private static const FRAME:int = 6;
		private static const FRAME_RATE:int = 100;

		public function MapObjects() {
			x = Const.MAP_OFFSET_X;
			y = Const.MAP_OFFSET_Y;

			Utils.loadBinary(Const.ASSETS_DOMAIN + "objects.bin", function(bytes:ByteArray):void {
				struct = new StructObjects(bytes);
				var t:Timer = new Timer(1000);
				t.addEventListener(TimerEvent.TIMER, function(e){update()});
				t.start();
			});

			var row:Sprite;
			var sp:Sprite;
			var bmp:Bitmap;
			var w:int, h:int;
			objs = new Vector.<Bitmap>();
			for (h = 0; h < Const.TILE_Y; h++) {
				row = new Sprite();
				for (w = 0; w < Const.TILE_X; w++) {
					sp = new Sprite();
					sp.x = Const.TILE_W * w;
					sp.y = Const.TILE_H * h;
					bmp = new Bitmap();
					objs.push(bmp);
					sp.addChild(bmp);
					sp.graphics.beginFill(0xffffff);
					sp.graphics.drawCircle(0,0,1);
					sp.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
						(e.target as Sprite).filters = [Filters.red];
						(e.target as Sprite).parent.alpha = 0.3;
					});
					sp.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
						(e.target as Sprite).filters = [];
						(e.target as Sprite).parent.alpha = 1;
					});
					row.addChild(sp);
				}
				addChild(row);
			}
		}

		public function f1():void {
			stepsX ? x = stepsX[idx] : null;
			stepsY ? y = stepsY[idx] : null;
			++idx;
		}

		public function f2():void {
			if (stepsX) {
				x = stepsX.pop();
				mX = mX_;
			}
			if (stepsY) {
				y = stepsY.pop();
				mY = mY_;
			}
			idx = 0;
			stepsX = stepsY = null;
			update(true);
		}

		public function get mapX():int { return mX; }
		public function get mapY():int { return mY; }

		public function set mapX(n:int):void {
			stepsX = Utils.steps(x, Const.TILE_W * (mX - n) + x, FRAME);
			mX_ = n;
		}

		public function set mapY(n:int):void {
			stepsY = Utils.steps(y, Const.TILE_H * (mY - n) + y, FRAME);
			mY_ = n;
		}

		private function update(active:Boolean=false):void {
			if (!struct) return;
			var w:int, h:int, i:int;
			if (active) {
				x = Const.MAP_OFFSET_X;
				y = Const.MAP_OFFSET_Y;
			}
			for (h = 0; h < Const.TILE_Y; h++) {
				for (w = 0; w < Const.TILE_X; w++) {
					setTile(objs[i++], w + mX, h + mY, active);
				}
			}
		}

		private function setTile(bmp:Bitmap, x:int, y:int, active:Boolean=false):void {
			var s:String;
			var data:MirBitmapData;
			if (x >= 0 && y >= 0) {
				if (!active && bmp.bitmapData) return;
				data = struct.g(x, y);
				bmp.bitmapData = data;
				if (data) {
					bmp.x = data.x - data.width;
					bmp.y = data.y - data.height;
				}
			}
		}
	}
}