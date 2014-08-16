package {
	import flash.display.Bitmap;
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
	
	import mir.Const;
	import mir.Hero;
	import mir.Utils;
	
	
	public class mir extends Sprite {
		public function mir() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.color = 0x808080;

			addChild(new Ground());

			for (var i:int = 0; i < 100; i++) {
				var h:Hero = new Hero();
				h.x = Math.random() * 1800;
				h.y = Math.random() * 900;
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
