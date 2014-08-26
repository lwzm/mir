package mir {
	import flash.geom.Point;

	public class CoordinateSystem {
		private var center:Point;
		private var directions:uint;
		private var atan2List:Array;
		private var zone1:Vector.<uint>;
		private var zone2:Vector.<uint>;

		public function CoordinateSystem(c:Point, d:uint) {
			var z:int;
			var n:Number;
			var delta:Number;
			atan2List = [];
			zone1 = new Vector.<uint>();
			zone2 = new Vector.<uint>();
			center = c;
			directions = d;
			d /= 2;  // half circular
			delta = Math.PI / d;

			for (n = Math.PI / d / 2; n < Math.PI; n += delta) {
				atan2List.push(Math.atan2(Math.sin(n), Math.cos(n)));
			}

			for (z = d / 2; z >= 0; z--) {
				zone1.push(z);
			}
			for (z = d * 2 - 1; z >= d + d / 2; z--) {
				zone1.push(z);
			}
			for (z = d / 2; z < d + 1 + d / 2; z++) {
				zone2.push(z);
			}
		}

		public function direction(p:Point):uint {
			var x:int = p.x - center.x;
			var y:int = p.y - center.y;
			var atan2:Number = Math.abs(Math.atan2(y, x));
			var i:int;
			for (i = 0; i < atan2List.length; i++) {
				if (atan2List[i] > atan2) {
					break;
				}
			}
			return y < 0 ? zone1[i] : zone2[i];
		}
	}
}