package
{
	public class T
	{
		public function T()
		{
		}
		public function get a():Array {
			trace(this);
			return [1,2,3];
		}
		public function f():void {
			a[1];
		}
	}
}