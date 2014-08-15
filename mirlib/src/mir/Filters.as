package mir {
	import flash.filters.ColorMatrixFilter;

	public class Filters {
		public static const highlight:ColorMatrixFilter = new ColorMatrixFilter([
			1, 0, 0, 0, 30,
			0, 1, 0, 0, 30,
			0, 0, 1, 0, 30,
			0, 0, 0, 1, 0,
		]);
		public static const translucent:ColorMatrixFilter = new ColorMatrixFilter([
			1, 0, 0, 0, 0,
			0, 1, 0, 0, 0,
			0, 0, 1, 0, 0,
			0, 0, 0, .5, 0,
		]);
		public static const red:ColorMatrixFilter = new ColorMatrixFilter([
			.8, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0,
		]);
		public static const green:ColorMatrixFilter = new ColorMatrixFilter([
			0, 0, 0, 0, 0,
			0, .8, 0, 0, 0,
			0, 0, 0, 0, 0,
			0, 0, 0, 1, 0,
		]);
		public static const gray:ColorMatrixFilter = new ColorMatrixFilter([
			.3, .3, .3, 0, 0,
			.3, .3, .3, 0, 0,
			.3, .3, .3, 0, 0,
			0, 0, 0, 1, 0,
		]);
	}
}