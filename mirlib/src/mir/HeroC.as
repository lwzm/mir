package mir {
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;

	public final class HeroC {
		public static const DELAIES:Vector.<int> = Vector.<int>([500, 100, 100, 100, 100, 100, 100, 100, 200, 100, 150]);

		private const timer:Timer = new Timer(100);
		private const initFactories:Vector.<Function> = new Vector.<Function>(11);
		private const states:Vector.<Boolean> = new Vector.<Boolean>(11);
		
		public var hero:Hero;
		public var scene:Scene;
		public var stage:Stage;
		private var stepX:Vector.<int>;
		private var stepY:Vector.<int>;

		public function HeroC(stage:Stage, hero:Hero, scene:Scene) {
			this.hero = hero;
			this.scene = scene;
			this.stage = stage;
			
			states[Hero.MOTION_DEFAULT] = true;

			initFactories[Hero.MOTION_DEFAULT] = _default;
			initFactories[Hero.MOTION_WALK] = _walk;
			initFactories[Hero.MOTION_RUN] = _run;
			timer.addEventListener(TimerEvent.TIMER, timerTask);
			timer.start();

			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				motionStart(Hero.MOTION_WALK);
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
				motionStop(Hero.MOTION_WALK);
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void {
				motionStart(Hero.MOTION_RUN);
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:MouseEvent):void {
				motionStop(Hero.MOTION_RUN);
			});
		}

		private function dir():int {
			const p:Point = new Point(stage.mouseX, stage.mouseY);
			return Const.CENTER_COOR_8.direction(p);
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
					stepX = Const.WALK_DIRECTIONS_X_DELTA[d];
					stepY = Const.WALK_DIRECTIONS_Y_DELTA[d];
					if (scene) {
						scene.X += Const.DIRECTION_DELTA_X[d];
						scene.Y += Const.DIRECTION_DELTA_Y[d];
					}
					break;
				case Hero.MOTION_RUN:
					stepX = Const.RUN_DIRECTIONS_X_DELTA[d];
					stepY = Const.RUN_DIRECTIONS_Y_DELTA[d];
					if (scene) {
						scene.X += Const.DIRECTION_DELTA_X[d] * 2;
						scene.Y += Const.DIRECTION_DELTA_Y[d] * 2;
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
			if (hero.ended) {
				scene && scene.update();
				if (states[motion]) {
					motionStart(motion);
				}
			}
		}

		public function motionStart(motion:int):void {
			if (motion !== Hero.MOTION_DEFAULT) {
				states[motion] = true;
				if (hero.motion === Hero.MOTION_DEFAULT) {
					timer.delay = DELAIES[motion];  // fast recovery
				}
				hero.motion = motion;
				hero.direction = dir();
			}
//			timer.delay = DELAIES[motion];  // shake effection when stop move
		}

		public function motionStop(motion:int):void {
			states[motion] = false;
		}

	}
}