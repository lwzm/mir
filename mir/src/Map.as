package  {
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	
	import mir.Const;
	import mir.Filters;
	import mir.MirBitmapData;
	import mir.StructMapAnimations;
	import mir.StructMapGround;
	import mir.StructMapMiddle;
	import mir.StructMapObjects;
	import mir.Util;

	public class Map extends Sprite {
		public var viewX:int;
		public var viewY:int;

		public var ground:Sprite;
		public var middle:Sprite;
		public var objects:Sprite;
		public var rows:Vector.<Sprite>;
		public var others:Vector.<Sprite>;

		public var structGround:StructMapGround;
		public var structMiddle:StructMapMiddle;
		public var structObjects:StructMapObjects;
		public var structAnimations:StructMapAnimations;

		public var objs_bmp:Vector.<Bitmap>;

		public function Map(name:String) {
			ground = new Sprite();
			addChild(ground);

			middle = new Sprite();
//			addChild(middle);

			objects = new Sprite();
			addChild(objects);

			rows = new Vector.<Sprite>();
			others = new Vector.<Sprite>();

			var row:Sprite, other:Sprite, obj:Sprite;
			var bmp:Bitmap;
			var x:int, y:int;
			var deltaX:int = Const.TILE_W * (-2) + 7, deltaY:int = Const.TILE_H * (-2) - 44;  // fuck, i don't know
			for (y = Const.TILE_EDGE; y < Const.TILES_COUNT_H; y += 2) {
				for (x = Const.TILE_EDGE; x < Const.TILES_COUNT_W; x += 2) {
					bmp = new Bitmap();
					bmp.x = Const.TILE_W * x + deltaX;
					bmp.y = Const.TILE_H * y + deltaY;
					ground.addChild(bmp);
				}
			}
			for (y = Const.TILE_EDGE; y < Const.TILES_COUNT_H; y++) {
				for (x = Const.TILE_EDGE; x < Const.TILES_COUNT_W; x++) {
					bmp = new Bitmap();
					bmp.x = Const.TILE_W * x + deltaX;
					bmp.y = Const.TILE_H * y + deltaY;
					middle.addChild(bmp);
				}
			}
			objs_bmp = new Vector.<Bitmap>();
			for (y = Const.TILE_EDGE; y < Const.TILES_COUNT_H; y++) {
				row = new Sprite();
				addChild(row);
				rows.push(row);
				other = new Sprite();
				addChild(other);
				others.push(other);
				for (x = Const.TILE_EDGE; x < Const.TILES_COUNT_W; x++) {
					obj = new Sprite();
					row.addChild(obj);
					obj.x = Const.TILE_W * x;
					obj.y = Const.TILE_H * y;
					bmp = new Bitmap();
					obj.addChild(bmp);
					objs_bmp.push(bmp);
					obj.graphics.beginFill(0xffffff);
					obj.graphics.drawCircle(0,0,1);
					obj.addEventListener(MouseEvent.MOUSE_OVER, function(e:MouseEvent):void {
						(e.target as Sprite).filters = [Filters.red];
						(e.target as Sprite).parent.filters = [Filters.gray];
					});
					obj.addEventListener(MouseEvent.MOUSE_OUT, function(e:MouseEvent):void {
						(e.target as Sprite).filters = [];
						(e.target as Sprite).parent.filters = [];
					});
					/*
					*/
				}
			}

			Util.loadBinary(completeAssetUrl(name + ".ground"), function(bytes:ByteArray):void {
				structGround = new StructMapGround(bytes);
			});
			Util.loadBinary(completeAssetUrl(name + ".middle"), function(bytes:ByteArray):void {
				structMiddle = new StructMapMiddle(bytes);
			});
			Util.loadBinary(completeAssetUrl(name + ".objects"), function(bytes:ByteArray):void {
				structObjects = new StructMapObjects(bytes);
			});
			Util.loadString(completeAssetUrl(name + ".animations"), function(str:String):void {
				structAnimations = new StructMapAnimations(str);
			});
		}
		
		public function update():void {
			var x:int, y:int, i:int;
			var data:MirBitmapData;
			var sp:Sprite;
			var bmp:Bitmap;

			x = Const.TILE_W * viewX;
			y = Const.TILE_H * viewY;
			ground.x = middle.x = objects.x = x;
			ground.y = middle.y = objects.y = y;
			for each (sp in rows) {
				sp.x = x;
				sp.y = y;
			}

			i = 0;
			for (y = Const.TILE_EDGE; y < Const.TILES_COUNT_H; y += 2) {
				for (x = Const.TILE_EDGE; x < Const.TILES_COUNT_W; x += 2) {
					data = structGround.g(x + viewX, y + viewY);
					(ground.getChildAt(i++) as Bitmap).bitmapData = data;
				}
			}

			i = 0;
			for (y = Const.TILE_EDGE; y < Const.TILES_COUNT_H; y++) {
				for (x = Const.TILE_EDGE; x < Const.TILES_COUNT_W; x++) {
					data = structMiddle.g(x + viewX, y + viewY);
					(middle.getChildAt(i++) as Bitmap).bitmapData = data;
				}
			}

			i = 0;
			for (y = Const.TILE_EDGE; y < Const.TILES_COUNT_H; y++) {
				for (x = Const.TILE_EDGE; x < Const.TILES_COUNT_W; x++) {
					data = structObjects.g(x + viewX, y + viewY);
					bmp = objs_bmp[i++];
					bmp.bitmapData = data;
					if (data) {
						bmp.x = data.x - data.width;
						bmp.y = data.y - data.height;
						if (bmp.blendMode !== BlendMode.NORMAL) {
							bmp.blendMode = BlendMode.NORMAL;
						}
					} else {
						structAnimations.s(bmp, x + viewX, y + viewY, 0);
					}
				}
			}
		}


		private static function completeAssetUrl(name:String):String {
			return Const.ASSETS_DOMAIN + "map/" + name;
		}
	}
}