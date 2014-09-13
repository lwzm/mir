package mir {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	

	public final class Scene {
		public var name:String;
		public var sprite:Sprite;
		
		private const DIRECTION_MAP:Vector.<int> = Vector.<int>([4, 5, 6, 7, 0, 1, 2, 3]);

		public var X:int;
		public var Y:int;

		private var timer:Timer;

		public var structGround:StructMapGround;
		public var structMiddle:StructMapMiddle;
		public var structObjects:StructMapObjects;
		public var structAnimations:StructMapAnimations;

		private var groundBmps:Vector.<Bitmap>;
		private var middleBmps:Vector.<Bitmap>;
		private var objectBmps:Vector.<Bitmap>;
		private var animateBmps:Vector.<Bitmap>;
		private var rows:Vector.<Sprite>;
		private var hitAreas:Vector.<Sprite>;
		private var shadows:Sprite;

		public function Scene(n:String) {
			name = n;
			sprite = new Sprite();
			sprite.mouseEnabled = false;
			shadows = new Sprite();
			shadows.mouseEnabled = false;
			shadows.mouseChildren = false;
			rows = new Vector.<Sprite>();
			hitAreas = new Vector.<Sprite>();
			groundBmps = new Vector.<Bitmap>();
			middleBmps = new Vector.<Bitmap>();
			objectBmps = new Vector.<Bitmap>();
			animateBmps = new Vector.<Bitmap>();
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
				i += Const.TILES_COUNT_UP;
				if (i === rows.length) {
					rows.push(sprite.addChild(new Sprite()));
				}
				objectBmps.push(rows[i].addChild(new Bitmap()));
			});
			loop(function(i:int, j:int, k:int):void {
				i += Const.TILES_COUNT_UP;
				if (i === hitAreas.length) {
					hitAreas.push(sprite.addChild(new Sprite()));
				}
			});
			hitAreas.reverse();
			loop(function(i:int, j:int, k:int):void {
				animateBmps.push(sprite.addChild(new Bitmap()));
			});
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

			timer = new Timer(200);
			timer.addEventListener(TimerEvent.TIMER, animate);
//			timer.start();
		}
		
        private function _animate(i:int, j:int, k:int):void {
            var bmp:Bitmap;
            var data:MirBitmapData;
            var x:int, y:int;
            x = X + j;
            y = Y + i;
            bmp = animateBmps[k];
            bmp.x = dispX(x);
            bmp.y = dispY(y);
			x >= 0 && y >= 0 && structAnimations.s(bmp, x, y, timer.currentCount);
		}

		private function animate(e:TimerEvent):void {
			structAnimations && loop(_animate);
		}

        private function _update(i:int, j:int, k:int):void {
            var bmp:Bitmap;
            var data:MirBitmapData;
            var x:int, y:int;
            x = X + j;
            y = Y + i;

            bmp = middleBmps[k];
            bmp.bitmapData = structMiddle.g(x, y);
            bmp.x = dispX(x);
            bmp.y = dispY(y);

            bmp = groundBmps[k];
            if (bmp) {
                bmp.bitmapData = structGround.g(x, y);
                bmp.x = dispX(x - (x & 0x01));
                bmp.y = dispY(y - (y & 0x01));
            }

            bmp = objectBmps[k];
            data = structObjects.g(x, y);
            bmp.bitmapData = data;
            if (data) {
                bmp.x = dispX(x + 1) - data.width;
                bmp.y = dispY(y + 1) - data.height;
            }
        }

		public function update():void {
			sprite.x = -Const.TILE_W * X;
			sprite.y = -Const.TILE_H * Y;
			loop(_update);
		}

		private function dispX(n:int):int {
            return Const.TILE_W * n + 376;
        }
		private function dispY(n:int):int {
            return Const.TILE_H * n + 209;
        }

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
                case Hero.MOTION_WALK:
                    deltaX = Const.WALK_DIRECTIONS_X_DELTA[direction];
                    deltaY = Const.WALK_DIRECTIONS_Y_DELTA[direction];
                    break;
                case Hero.MOTION_RUN:
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

		public function place(x:int, y:int, hero:Hero):void {
			var y_:int = y - Y + Const.TILES_COUNT_UP;
			if (y_ >= 0) {
				rows[y_].addChild(hero);
				hitAreas[y_].addChild(hero.hitArea);
				shadows.addChild(hero.shadow);
			}
            hero.x = dispX(x);
            hero.y = dispY(y);
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
