package mir {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	

	public final class Scene {
		public var name:String;
		public const sprite:Sprite = new Sprite();
		private const shadows:Sprite = new Sprite();
		
		public var X:int;
		public var Y:int;

		public var structGround:StructMapGround;
		public var structMiddle:StructMapMiddle;
		public var structObjects:StructMapObjects;
		public var structAnimations:StructMapAnimations;

		private const groundBmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private const middleBmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private const objectBmps:Vector.<Bitmap> = new Vector.<Bitmap>();
		private const rows:Vector.<Sprite> = new Vector.<Sprite>();
		private const hitRows:Vector.<Sprite> = new Vector.<Sprite>();

		public function Scene(n:String) {
			name = n;
			sprite.mouseEnabled = false;
			shadows.mouseEnabled = false;
			loop(function(i:int, j:int, k:int):void {
				var bmp:Bitmap;
				if (i % 2 === 0 && j % 2 === 0) {
                    groundBmps.push(sprite.addChild(new Bitmap()));
				} else {
					groundBmps.push(null);
				}
			});
			loop(function(i:int, j:int, k:int):void {
				middleBmps.push(sprite.addChild(new Bitmap()));
			});
			loop(function(i:int, j:int, k:int):void {
				i += Const.TILES_COUNT_UP;  // i start from 0
				if (i === rows.length) {
					rows.push(sprite.addChild(new Sprite()));
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
					hitRows.push(sprite.addChild(new Sprite()));
				}
			});
			hitRows.reverse();

			sprite.addChild(shadows);
			
			Util.loadBinary(completeAssetUrl("ground"), function(bytes:ByteArray):void {
				structGround = new StructMapGround(bytes);
			});
			Util.loadBinary(completeAssetUrl("middle"), function(bytes:ByteArray):void {
				structMiddle = new StructMapMiddle(bytes);
			});
			Util.loadBinary(completeAssetUrl("objects"), function(bytes:ByteArray):void {
				structObjects = new StructMapObjects(bytes);
			});
			Util.loadString(completeAssetUrl("animations"), function(str:String):void {
				structAnimations = new StructMapAnimations(str);
			});

		}
		
		/*
        private function _animate(i:int, j:int, k:int):void {
            var bmp:Bitmap;
            var data:MirBitmapData;
            var x:int, y:int;
            x = X + j;
            y = Y + i;
            bmp = objectBmps[k];
			x >= 0 && y >= 0 && structAnimations.s(bmp, x, y, timer.currentCount, dispX(x+1), dispY(y+1));
		}

		private function animate(e:TimerEvent):void {
			structAnimations && loop(_animate);
		}
		*/

        private function _update(i:int, j:int, k:int):void {
            var bmp:Bitmap;
            var data:MirBitmapData;
            const x:int = X + j;
            const y:int = Y + i;

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

		public function update(..._):void {
			sprite.x = -Const.TILE_W * X;
			sprite.y = -Const.TILE_H * Y;
			structGround && structMiddle && structObjects && loop(_update);
		}

		private function dispX(n:int):int {
            return Const.TILE_W * n + Const.HERO_X;
        }
		private function dispY(n:int):int {
            return Const.TILE_H * n + Const.HERO_Y;
        }

		/**
		private function _move(deltaX:int, deltaY:int):Function {
            return function():void {
                sprite.x += deltaX;
                sprite.y += deltaY;
            }
        }

		public function move(direction:int, type:int):Vector.<Function> {
            var deltaX:Vector.<int>, deltaY:Vector.<int>;
			var funcs:Vector.<Function>;
			var i:int;
			direction = DIRECTION_MAP[direction];
            switch (type) {
                case Hero0.MOTION_WALK:
                    deltaX = Const.WALK_DIRECTIONS_X_DELTA[direction];
                    deltaY = Const.WALK_DIRECTIONS_Y_DELTA[direction];
                    break;
                case Hero0.MOTION_RUN:
                    deltaX = Const.RUN_DIRECTIONS_X_DELTA[direction];
                    deltaY = Const.RUN_DIRECTIONS_Y_DELTA[direction];
                    break;
                default:
                    throw Error;
                    break;
            }
            funcs = new Vector.<Function>();
			do {
                funcs.push(_move(deltaX[i], deltaY[i]));
			} while (++i < 5);
			return funcs
		}
		*/

		public function place(x:int, y:int, hero:Hero, reset:Boolean=false):void {
			var y_:int = y - Y + Const.TILES_COUNT_UP;
			if (y_ >= 0) {
				rows[y_].addChild(hero);
				shadows.addChild(hero.shadow);
				hitRows[y_].addChild(hero.hitArea);
			}
			if (reset) {
				hero.x = dispX(x);
				hero.y = dispY(y);
			}
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
			return Const.ASSETS_DOMAIN + "map/" + name + "." + suffix;
		}

	}
}
