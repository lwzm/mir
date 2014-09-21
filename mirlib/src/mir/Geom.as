package mir {
	import flash.geom.Point;

	public final class Geom {
		public static const VIEW_CENTER:Point = new Point(400, 220);
		public static const CENTER_COOR_8:CoordinateSystem = new CoordinateSystem(VIEW_CENTER,8);
		public static const CENTER_COOR_16:CoordinateSystem = new CoordinateSystem(VIEW_CENTER, 16);
		public static const DIRECTION_DELTA_X:Vector.<int> = Vector.<int>([0, 1, 1, 1, 0, -1, -1, -1]);
		public static const DIRECTION_DELTA_Y:Vector.<int> = Vector.<int>([-1, -1, 0, 1, 1, 1, 0, -1]);
		public static const DELTA_ZERO:Vector.<int>    = Vector.<int>([0, 0, 0, 0, 0, 0]);
		public static const DELTA_1_UP:Vector.<int>    = Vector.<int>([-4, -6, -6, -6, -6, -4]);
		public static const DELTA_1_DOWN:Vector.<int>  = Vector.<int>([+4, +6, +6, +6, +6, +4]);
		public static const DELTA_1_LEFT:Vector.<int>  = Vector.<int>([-8, -8, -8, -8, -8, -8]);
		public static const DELTA_1_RIGHT:Vector.<int> = Vector.<int>([+8, +8, +8, +8, +8, +8]);
		public static const DELTA_2_UP:Vector.<int>    = Vector.<int>([-10, -10, -12, -12, -10, -10]);
		public static const DELTA_2_DOWN:Vector.<int>  = Vector.<int>([+10, +10, +12, +12, +10, +10]);
		public static const DELTA_2_LEFT:Vector.<int>  = Vector.<int>([-16, -16, -16, -16, -16, -16]);
		public static const DELTA_2_RIGHT:Vector.<int> = Vector.<int>([+16, +16, +16, +16, +16, +16]);
		public static const WALK_DIRECTIONS_X_DELTA:Vector.<Vector.<int>> = Vector.<Vector.<int>>([
			DELTA_ZERO,
			DELTA_1_RIGHT,
			DELTA_1_RIGHT,
			DELTA_1_RIGHT,
			DELTA_ZERO,
			DELTA_1_LEFT,
			DELTA_1_LEFT,
			DELTA_1_LEFT,
		]);
		public static const WALK_DIRECTIONS_Y_DELTA:Vector.<Vector.<int>> = Vector.<Vector.<int>>([
			DELTA_1_UP,
			DELTA_1_UP,
			DELTA_ZERO,
			DELTA_1_DOWN,
			DELTA_1_DOWN,
			DELTA_1_DOWN,
			DELTA_ZERO,
			DELTA_1_UP,
		]);
		public static const RUN_DIRECTIONS_X_DELTA:Vector.<Vector.<int>> = Vector.<Vector.<int>>([
			DELTA_ZERO,
			DELTA_2_RIGHT,
			DELTA_2_RIGHT,
			DELTA_2_RIGHT,
			DELTA_ZERO,
			DELTA_2_LEFT,
			DELTA_2_LEFT,
			DELTA_2_LEFT,
		]);
		public static const RUN_DIRECTIONS_Y_DELTA:Vector.<Vector.<int>> = Vector.<Vector.<int>>([
			DELTA_2_UP,
			DELTA_2_UP,
			DELTA_ZERO,
			DELTA_2_DOWN,
			DELTA_2_DOWN,
			DELTA_2_DOWN,
			DELTA_ZERO,
			DELTA_2_UP,
		]);
	}
}