package mir {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	

	public final class MapObjects extends MapBase {
		public var objs:Vector.<Bitmap>;
		
		private var structAnimations:StructMapAnimations;
		private var timer:Timer;

		public function MapObjects(name:String) {
			super(name + ".objects");
			Util.loadString(completeAssetUrl(name + ".animations"), buildAnimations);
			timer = new Timer(200);
		}

		private function buildAnimations(s:String):void {
			structAnimations = new StructMapAnimations(s);
			timer.addEventListener(TimerEvent.TIMER, animate);
			timer.start();
		}

		override protected function get StructClass():Class { return StructMapObjects; }

		override protected function initChildren():void {
			var row:Sprite;
			var sp:Sprite;
			var bmp:Bitmap;
			var w:int, h:int;
			objs = new Vector.<Bitmap>();
			for (h = Const.TILE_EDGE; h < Const.TILES_COUNT_H; h++) {
				row = new Sprite();
				for (w = Const.TILE_EDGE; w < Const.TILES_COUNT_W; w++) {
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
						(e.target as Sprite).parent.filters = [Filters.gray];
					});
					sp.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
						(e.target as Sprite).filters = [];
						(e.target as Sprite).parent.filters = [];
					});
					/*
					*/
					row.addChild(sp);
				}
				addChild(row);
			}
		}

		override protected function update(active:Boolean=false):void {
			var w:int, h:int, i:int;
			if (active) {
				x = Const.MAP_OFFSET_X;
				y = Const.MAP_OFFSET_Y;
			}
			for (h = Const.TILE_EDGE; h < Const.TILES_COUNT_H; h++) {
				for (w = Const.TILE_EDGE; w < Const.TILES_COUNT_W; w++) {
					setTile(objs[i++], w + mX, h + mY, active);
				}
			}
			structAnimations && animate(null);
		}

		private function setTile(bmp:Bitmap, x:int, y:int, active:Boolean):void {
			var data:MirBitmapData;
			if (x >= 0 && y >= 0) {
				if (!active && bmp.bitmapData) return;
				data = struct.g(x, y);
				bmp.bitmapData = data;
				if (data) {
					bmp.x = data.x - data.width;
					bmp.y = data.y - data.height;
					if (bmp.blendMode !== BlendMode.NORMAL) {
						bmp.blendMode = BlendMode.NORMAL;
					}
				}
			}
		}
		
		private function animate(e:TimerEvent):void {
			var w:int, h:int, i:int, t:int, n:int;
			var bmp:Bitmap;
			n = timer.currentCount;
			for (h = Const.TILE_EDGE; h < Const.TILES_COUNT_H; h++) {
				for (w = Const.TILE_EDGE; w < Const.TILES_COUNT_W; w++) {
					setAnimation(objs[i++], w + mX, h + mY, n);
				}
			}
		}

		private function setAnimation(bmp:Bitmap, x:int, y:int, n:int):void {
			x >= 0 && y >= 0 && structAnimations.s(bmp, x, y, n);
		}

	}
}