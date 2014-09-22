package  {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.System;
	import flash.utils.Timer;
	
	import mir.Const;
	import mir.CoordinateSystem;
	import mir.Filters;
	import mir.Hero;
	import mir.HeroC;
	import mir.Monster;
	import mir.Res;
	import mir.Scene;
	import mir.Util;
	
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="50")]
	public class mir extends Sprite {

		public function mir() {
			initStage();
			var s:Scene = new Scene("0");
			var h:Hero = new Hero(true);
			var m:Monster = new Monster();
			m.body = 111;
			var t:Timer = new Timer(100);
			t.addEventListener(TimerEvent.TIMER, function(e){m.ani();m.motion=7});
			t.start();
			h.body = 3;
			h.weapon = 17;
			h.hair = 2;
			addChild(s.sprite);
			s.X = 325;
			s.Y = 45;
			s.place(s.X, s.Y, h);
			s.place(s.X + 1, s.Y-3, m);
			var hc:HeroC = new HeroC(stage, h, s);
		}

		private function initStage():void {
			Debug.monitor(stage);
//			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			Util.autoGc();
		}
	}
}
