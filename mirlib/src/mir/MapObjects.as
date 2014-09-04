package mir {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	

	public final class MapObjects extends MapBase {
		public var objs:Vector.<Bitmap>;

		public function MapObjects() {
			super("objects.bin")
		}

		override protected function initStruct(bytes:ByteArray):void {
			struct = new StructMapObjects(bytes);
		}

		override protected function initChildren():void {
			var row:Sprite;
			var sp:Sprite;
			var bmp:Bitmap;
			var w:int, h:int;
			objs = new Vector.<Bitmap>();
			for (h = Const.TILE_EDGE; h < Const.TILE_Y; h++) {
				row = new Sprite();
				for (w = Const.TILE_EDGE; w < Const.TILE_X; w++) {
					sp = new Sprite();
					sp.x = Const.TILE_W * w;
					sp.y = Const.TILE_H * h;
					bmp = new Bitmap();
					objs.push(bmp);
					sp.addChild(bmp);
					/*
					sp.graphics.beginFill(0xffffff);
					sp.graphics.drawCircle(0,0,1);
					sp.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
						(e.target as Sprite).filters = [Filters.highlight];
						(e.target as Sprite).parent.alpha = 0.6;
					});
					sp.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
						(e.target as Sprite).filters = [];
						(e.target as Sprite).parent.alpha = 1;
					});
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
			for (h = Const.TILE_EDGE; h < Const.TILE_Y; h++) {
				for (w = Const.TILE_EDGE; w < Const.TILE_X; w++) {
					setTile(objs[i++], w + mX, h + mY, active);
				}
			}
		}

		private function setTile(bmp:Bitmap, x:int, y:int, active:Boolean):void {
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