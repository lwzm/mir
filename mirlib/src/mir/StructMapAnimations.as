package mir {
	import flash.display.Bitmap;
	import flash.display.BlendMode;

	public final class StructMapAnimations extends StructMapBase {
		private var animations:Object;

		public function StructMapAnimations(string:String) {
			var idx:int, i:int, j:int;
			animations = JSON.parse(string);
			w = animations.w;
			h = animations.h;
		}

		public function s(bmp:Bitmap, x:int, y:int, count:int):void {
			var idx:int, arr:Array, i:int, j:int, n:int, blendAdd:Boolean;
			var data:MirBitmapData;
			idx = w * y + x;
			arr = animations[idx];
			if (arr) {
				i = arr[0];
				j = arr[1] - 1;
				n = arr[2];
				blendAdd = arr[3];
				bmp.blendMode = blendAdd ? BlendMode.ADD : BlendMode.NORMAL;
				data = Res.objects[i].g((j + count % n).toString());
				if (data) {
					bmp.bitmapData = data;
					// i guess (7, -44), haha...
					bmp.x = 7 + data.x - data.width;
					bmp.y = -44 + data.y - data.height;
				}
			}
		}
	}
}