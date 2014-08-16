package mir {

	public class Multiple extends Single {
		public static const dummy:Array = [null]; 

		public function Multiple(category:String, dummy:Boolean=false) {
			super(category, dummy);
		}
		
		override public function prepair(name:String):void {
			all[name] = dummy;
			Utils.loadMirBitmaps(urlPrefix + name, function(arr:Array):void {
				all[name] = arr;
			});
		}

	}
}