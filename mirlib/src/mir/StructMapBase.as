package mir {
	public class StructMapBase {
		protected var w:int;
		protected var h:int;

		public function get width():int { return w; }
		public function get height():int { return h; }

		public function g(x:int, y:int):MirBitmapData { throw Error; }
	}
}