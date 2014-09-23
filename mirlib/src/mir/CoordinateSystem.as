package mir {
	import flash.geom.Point;

	public class CoordinateSystem {
		public const lasts:Vector.<uint> = new Vector.<uint>();
		public const nexts:Vector.<uint> = new Vector.<uint>();

		private const atan2Directions:Vector.<Number> = new Vector.<Number>();
		private const zone1Directions:Vector.<uint> = new Vector.<uint>();
		private const zone2Directions:Vector.<uint> = new Vector.<uint>();
		private const atan2Areas:Vector.<Number> = new Vector.<Number>();
		private const zone1Areas:Vector.<uint> = new Vector.<uint>();
		private const zone2Areas:Vector.<uint> = new Vector.<uint>();
		private var center:Point;
		private var directions:uint;

		public function CoordinateSystem(center:Point, directions:uint) {
			this.center = center;
			this.directions = directions;
			init();
		}

		private function init():void {
			// lasts and nexts
			var i:int;
			lasts.push(directions - 1);
			lasts.push(0);
			for (i = 1; i < directions - 1; i++) {
				lasts.push(i);
				nexts.push(i);
			}
			nexts.push(directions - 1);
			nexts.push(0);

			const d:uint = directions / 2;  // half circular
			const delta:Number = Math.PI / d;
			var z:int, n:Number;

			// directions
			for (n = Math.PI / d / 2; n < Math.PI; n += delta) {
				atan2Directions.push(Math.atan2(Math.sin(n), Math.cos(n)));
			}
			for (z = d / 2; z >= 0; z--) {
				zone1Directions.push(z);
			}
			for (z = d * 2 - 1; z >= d + d / 2; z--) {
				zone1Directions.push(z);
			}
			for (z = d / 2; z < d + 1 + d / 2; z++) {
				zone2Directions.push(z);
			}
//			trace(atan2Directions)
//			trace(zone1Directions)
//			trace(zone2Directions)

			// areas
			for (n = Math.PI / d; n < Math.PI + 0.001; n += delta) {
				atan2Areas.push(Math.atan2(Math.sin(n), Math.cos(n)));
			}
			for (z = d / 2 - 1; z >= 0; z--) {
				zone1Areas.push(z);
			}
			for (z = d * 2 - 1; z >= d + d / 2; z--) {
				zone1Areas.push(z);
			}
			for (z = d / 2; z < d + d / 2; z++) {
				zone2Areas.push(z);
			}
//			trace(atan2Areas);
//			trace(zone1Areas)
//			trace(zone2Areas)

		}

		public function direction(p:Point):uint {
			const x:int = p.x - center.x;
			const y:int = p.y - center.y;
			const atan2:Number = Math.abs(Math.atan2(y, x));
			const l:int = atan2Directions.length;
			var i:int;
			for (i = 0; i < l; i++) {
				if (atan2Directions[i] >= atan2) {
					break;
				}
			}
			return y < 0 ? zone1Directions[i] : zone2Directions[i];
		}

		public function area(p:Point):uint {
			const x:int = p.x - center.x;
			const y:int = p.y - center.y;
			const atan2:Number = Math.abs(Math.atan2(y, x));
			const l:int = atan2Areas.length;
			var i:int;
			for (i = 0; i < l; i++) {
				if (atan2Areas[i] >= atan2) {
					break;
				}
			}
			return y < 0 ? zone1Areas[i] : zone2Areas[i];
		}

	}
}