package  {
	import com.hexagonstar.util.debug.Debug;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
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
	import mir.Res;
	import mir.Scene;
	import mir.Util;
	
	
	[SWF(width="800", height="600", backgroundColor="#808080", frameRate="50")]
	public class mir extends Sprite {

		private var center:Point = new Point(400, 220);
		private var coor:CoordinateSystem = new CoordinateSystem(center, 8);
		private var floor:int;
		
		private var states:Vector.<Boolean> = new Vector.<Boolean>(11);

		public function mir() {
			initStage();
			var s:Scene = new Scene("0");
			var h:Hero = new Hero(true);
			h.body = 3;
			h.weapon = 17;
			h.hair = 2;
			addChild(s.sprite);
			s.X = 325;
			s.Y = 45;
			s.place(s.X, s.Y, h, true);
			var hc:HeroC = new HeroC(stage, h, s);
		}

		private function initStage():void {
			Debug.monitor(stage);
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			Util.autoGc();
		}
	}
}
