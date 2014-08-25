package {
	import flash.geom.Point;

	public class CoordinateSystem {
		public var center:Point;
		public var directions:uint;
		public var atan2List:Array;
		public var zone1:Object;
		public var zone2:Object;

		public function CoordinateSystem(c:Point, d:uint) {
			var i:int;
			var z:int;
			var n:Number;
			var delta:Number;
			atan2List = [];
			zone1 = {};
			zone2 = {};
			center = c;
			directions = d;
			d /= 2;
			delta = Math.PI / d;

			for (n = Math.PI / d / 2; n < Math.PI; n += delta) {
				atan2List.push(Math.atan2(Math.sin(n), Math.cos(n)));
			}
			trace(atan2List);

			for (z = d / 2, i = 0; z >= 0; i++, z--) {
				zone1[i] = z;
				trace(i, z);
			}
			for (z = d * 2 - 1; z >= d + d / 2; i++, z--) {
				zone1[i] = z;
				trace(i, z);
			}
			for (z = d / 2, i = 0; z < d + 1 + d / 2; i++, z++) {
				zone2[i] = z;
				trace(i, z);
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