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
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="60")]
	public class mir extends Sprite {

		public function mir() {
			Debug.monitor(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 

//			addChild(new Ground());

			var arr = [];
			for (var i:int = 0; i < 1; i++) {
				var h:Hero = new Hero();
				h.x = 0*Math.random() * 800;
				h.y = 600//Math.random() * 600;
				h.hair=2;
				h.sex = 0//Math.random() * 2;
				h.direction = 0//Math.random() * 8;
				h.body = 0//Math.random() * 6;
				h.weapon = 25//Math.random() * 25;
				addChild(h);
				arr.push(h);
//				addChild(h.shadow);
			}
			for each (var v in arr) {
				addChild(v.shadow);
			}
			for each (var v in arr) {
				addChild(v.hitArea);
			}
		}
	}
}
