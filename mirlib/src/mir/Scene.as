package mir {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	

	public final class Scene extends Sprite {
		public var mapName:String;
		private const shadows:Sprite = new Sprite();
		private const record:Dictionary = new Dictionary(true);
		
		public var X:int;
		public var Y:int;


		public var structMask:StructMapMask;
		public var structGround:StructMapGround;
		public var structMiddle:StructMapMiddle;
		public var structObjects:StructMapObjects;
		public var structAnimations:StructMapAnimations;

		public var showMask:Boolean;  // for developer
		private const mask1Bmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private const mask2Bmps:Vector.<Bitmap> = new Vector.<Bitmap>();

		private const groundBmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private const middleBmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private const objectBmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private const rows:Vector.<Sprite> = new Vector.<Sprite>();
		private const hitRows:Vector.<Sprite> = new Vector.<Sprite>();

		public function Scene(name:String) {
			mapName = name;
			shadows.mouseEnabled = false;

			loop(function(i:int, j:int, k:int):void {
				var bmp:Bitmap;
				if (i % 2 === 0 && j % 2 === 0) {
                    groundBmps.push(addChild(new Bitmap()));
				} else {
					groundBmps.push(null);
				}
			});

			loop(function(i:int, j:int, k:int):void {
				middleBmps.push(addChild(new Bitmap()));
			});

			loop(function(i:int, j:int, k:int):void {
				i += Const.TILES_COUNT_UP;  // i start from 0
				if (i === rows.length) {
					rows.push(addChild(new Sprite()));
				}
				var sp:Sprite = new Sprite();
				rows[i].addChild(sp);
				objectBmps.push(sp.addChild(new Bitmap));
//				sp.addEventListener(MouseEvent.MOUSE_OVER, function(e:*):void {
//					sp.filters = [Filters.red];
//				});
//				sp.addEventListener(MouseEvent.MOUSE_OUT, function(e:*):void {
//					sp.filters = [];
//				});
//				sp.addEventListener(MouseEvent.CLICK, function(e:*):void {
//					//todo
//				});
			});

			loop(function(i:int, j:int, k:int):void {
				i += Const.TILES_COUNT_UP;  // i start from 0
				if (i === hitRows.length) {
					hitRows.push(addChild(new Sprite()));
				}
			});
			hitRows.reverse();

			addChild(shadows);
			
			Util.loadBinary(completeAssetUrl("mask"), function(bytes:ByteArray):void {
				structMask = new StructMapMask(bytes);
			}, true);
			Util.loadBinary(completeAssetUrl("ground"), function(bytes:ByteArray):void {
				structGround = new StructMapGround(bytes);
			}, true);
			Util.loadBinary(completeAssetUrl("middle"), function(bytes:ByteArray):void {
				structMiddle = new StructMapMiddle(bytes);
			}, true);
			Util.loadBinary(completeAssetUrl("objects"), function(bytes:ByteArray):void {
				structObjects = new StructMapObjects(bytes);
			}, true);
			Util.loadString(completeAssetUrl("animations"), function(str:String):void {
				structAnimations = new StructMapAnimations(str);
			});

		}
		
        private function _update(i:int, j:int, k:int):void {
            const x:int = X + j;
            const y:int = Y + i;
            var bmp:Bitmap;
            var data:MirBitmapData;

            bmp = groundBmps[k];
            if (bmp) {
                bmp.bitmapData = structGround.g(x, y);
                bmp.x = dispX(x - (x & 0x01));
                bmp.y = dispY(y - (y & 0x01));
            }

            bmp = middleBmps[k];
            bmp.bitmapData = structMiddle.g(x, y);
            bmp.x = dispX(x);
            bmp.y = dispY(y);

			if (showMask) {
				if (!mask1Bmps.length) {
					loop(function(i:int, j:int, k:int):void {
						mask1Bmps.push(addChild(new Bitmap()));
						mask2Bmps.push(addChild(new Bitmap()));
					});
				}
				bmp = mask1Bmps[k];
				bmp.bitmapData = structMask.m1(x, y) ? Res.tilesm.g("58") : null;
				bmp.x = dispX(x);
				bmp.y = dispY(y);
				bmp = mask2Bmps[k];
				bmp.bitmapData = structMask.m2(x, y) ? Res.tilesm.g("59") : null;
				bmp.x = dispX(x);
				bmp.y = dispY(y);
			} else if (mask1Bmps.length) {
				mask1Bmps[k].bitmapData = mask2Bmps[k].bitmapData = null;
			}

            bmp = objectBmps[k];
            data = structObjects.g(x, y);
            bmp.bitmapData = data;
            if (data) {
				if (bmp.blendMode !== BlendMode.NORMAL) {
					bmp.blendMode = BlendMode.NORMAL;
				}
                bmp.x = dispX(x + 1) - data.width;
                bmp.y = dispY(y + 1) - data.height;
            }
        }

		public function update():void {
			x = -Const.TILE_W * X;
			y = -Const.TILE_H * Y;
			structGround && structMiddle && structObjects && loop(_update);
			for (var role:Role in record) {
				placeRow(role, record[role]);
			}
//			var arr:Array = [];
//			rows.forEach(function(e:Sprite,i,a){arr.push(e.numChildren)});
//			trace(arr);
		}

		private function dispX(n:int):int {
            return Const.TILE_W * n + Const.HERO_X;
        }

		private function dispY(n:int):int {
            return Const.TILE_H * n + Const.HERO_Y;
        }

		public function placeRow(role:Role, y:int):void {
			y += Const.TILES_COUNT_UP - Y;
			if (y in rows) {
				rows[y].addChild(role);
				hitRows[y].addChild(role.hitArea);
			}
		}

		public function place(role:Role, x:int, y:int):void {
			shadows.addChild(role.shadow);
			role.x = dispX(x);
			role.y = dispY(y);
			record[role] = y;
		}
		
		private static function loop(f:Function):void {
			var i:int, j:int, k:int;
			k = 0;
			for (i = -Const.TILES_COUNT_UP; i < Const.TILES_COUNT_DOWN; i++) {
				for (j = -Const.TILES_COUNT_LEFT; j < Const.TILES_COUNT_RIGHT; j++, k++) {
					f(i, j, k);
				}
			}
		}

		private function completeAssetUrl(suffix:String):String {
			return Const.ASSETS_DOMAIN + "map/" + mapName + "." + suffix;
		}

	}
}
