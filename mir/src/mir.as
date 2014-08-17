package {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.utils.Timer;
	import flash.utils.describeType;
	
	import mir.Const;
	import mir.Hero;
	import mir.Utils;
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="20")]
	public class mir extends Sprite {
		[Embed(source="43.png")]
		private var test:Class;

		public function mir() {
			Debug.monitor(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 

			stage.addChild(new Ground());
			stage.addChild(this);
			this.x = -100000;
			this.y = -100000;

			for (var i:int = 0; i < 100; i++) {
				var h:Hero = new Hero();
				h.x = 100000+Math.random() * 800;
				h.y = 100000+Math.random() * 600;
				h.hair=2;
				h.sex = Math.random() * 2;
				h.direction = Math.random() * 8;
				h.body = Math.random() * 6;
				h.weapon = Math.random() * 25;
				h.motion = Math.random() * 11;
				addChild(h);
			}
		}
	}
}
