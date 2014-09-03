package mir {
	public class StructMapBase implements IMapStruct {
		protected var w:int;
		protected var h:int;
		protected var len:int;

		public function get width():int { return w; }
		public function get height():int { return h; }

		public function g(x:int, y:int):MirBitmapData { throw Error; }
	}
}