package mir {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public final class HeroC {
		public static const DELAIES:Vector.<int> = Vector.<int>([500, 50, 10, 100, 100, 100, 100, 100, 200, 100, 150]);

		private const initFactories:Vector.<Function> = new Vector.<Function>(11);
		private const states:Vector.<Boolean> = new Vector.<Boolean>(11);
		
		private var timer:Timer;
		public var hero:Hero;
		public var scene:Scene;
		public var stage:Stage;
		private var stepX:Vector.<int>;
		private var stepY:Vector.<int>;

		public function HeroC(stage:Stage, hero:Hero, scene:Scene) {
			this.hero = hero;
			this.scene = scene;
			this.stage = stage;
			init();
		}
			
		private function init():void {
			states[Role.MOTION_DEFAULT] = true;

			initFactories[Role.MOTION_DEFAULT] = _default;
			initFactories[Hero.MOTION_WALK] = _walk;
			initFactories[Hero.MOTION_RUN] = _run;

			timer = new Timer(100);
			timer.addEventListener(TimerEvent.TIMER, timerTask);

			hero.addEventListener(Role.EVENT_MOTION, motionDoing);
			hero.addEventListener(Role.EVENT_MOTION_END, motionEnded);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				motionStart(Hero.MOTION_WALK, true);
				states[Hero.MOTION_WALK] = true;
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
				states[Hero.MOTION_WALK] = false;
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void {
				motionStart(Hero.MOTION_RUN, true);
				states[Hero.MOTION_RUN] = true;
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:MouseEvent):void {
				states[Hero.MOTION_RUN] = false;
			});
			motionStart(Role.MOTION_DEFAULT);
		}

		private function dir():int {
			const p:Point = new Point(stage.mouseX, stage.mouseY);
			return Geom.CENTER_COOR_8.direction(p);
		}

		private function _default():void {
//			hero.motion = Hero.MOTION_DEFAULT;
		}

		private function _walk():void {
			__move(Hero.MOTION_WALK);
		}

		private function _run():void {
			__move(Hero.MOTION_RUN);
		}

		private function __move(motion:int):void {
			var d:int = hero.direction;
			switch (motion) {
				case Hero.MOTION_WALK:
					stepX = Geom.WALK_DIRECTIONS_X_DELTA[d];
					stepY = Geom.WALK_DIRECTIONS_Y_DELTA[d];
					if (scene) {
						scene.X += Geom.DIRECTION_DELTA_X[d];
						scene.Y += Geom.DIRECTION_DELTA_Y[d];
					}
					break;
				case Hero.MOTION_RUN:
					stepX = Geom.RUN_DIRECTIONS_X_DELTA[d];
					stepY = Geom.RUN_DIRECTIONS_Y_DELTA[d];
					if (scene) {
						scene.X += Geom.DIRECTION_DELTA_X[d] * 2;
						scene.Y += Geom.DIRECTION_DELTA_Y[d] * 2;
					}
					break;
				default:
					stepX = null;
					stepY = null;
					break;
			}
		}

		private function timerTask(e:TimerEvent):void {
			hero.ani();
		}

		private function motionDoing(e:Event):void {
			const motion:int = hero.motion;
			const move:Boolean = (motion === Hero.MOTION_WALK || motion === Hero.MOTION_RUN);
			const n:int = hero.n;
			if (n === 0) {
				initFactories[motion]();
				timer.delay = DELAIES[motion];
			}
			if (move) {
				const x:int = stepX[n];
				const y:int = stepY[n];
				hero.x += x;
				hero.y += y;
				if (scene) {
					scene.sprite.x -= x;
					scene.sprite.y -= y;
				}
			}
		}

		public function motionStart(motion:int, continuable:Boolean=false):void {
			timer.delay = DELAIES[motion];
			timer.start();
			if (motion !== Role.MOTION_DEFAULT) {
				hero.motion = motion;
				hero.direction = dir();
			}
		}

		private function motionEnded(e:Event):void {
			timer.stop();
			if (scene) {
				scene.place(scene.X, scene.Y, hero);
				scene.update();
			}
			if (states[hero.motion]) {
				hero.motion = hero.motion;
				hero.direction = dir();
				timer.start();
			}
		}

	}
}