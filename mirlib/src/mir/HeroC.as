package mir {
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public final class HeroC {
		public static const DELAIES:Vector.<int> = Vector.<int>([500, 80, 80, 100, 100, 100, 100, 100, 200, 100, 150]);

		private const initFactories:Vector.<Function> = new Vector.<Function>(11);
		private const states:Vector.<Boolean> = new Vector.<Boolean>(11);
		
		private const timer:Timer = new Timer(100);

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

			timer.addEventListener(TimerEvent.TIMER, hero.ani);

			hero.addEventListener(Role.EVENT_MOTION, motionDoing);
			hero.addEventListener(Role.EVENT_MOTION_END, motionEnded);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void {
				states[Hero.MOTION_WALK] = true;
				act();
			});
			stage.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void {
				states[Hero.MOTION_WALK] = false;
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, function(e:MouseEvent):void {
				states[Hero.MOTION_RUN] = true;
				act();
			});
			stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, function(e:MouseEvent):void {
				states[Hero.MOTION_RUN] = false;
			});
			timer.start();
			
		}

		private function mot(m, d):int {
			var x:int, y:int;
            if (m === Hero.MOTION_RUN) {
				x = scene.X + Geom.DIRECTION_DELTA_X[d] * 2;
				y = scene.Y + Geom.DIRECTION_DELTA_Y[d] * 2;
				if (scene.structMask.m1(x, y)) {
                    m = Hero.MOTION_WALK;
                }
            }
            return m
        }

		private function dir(move:Boolean=false):int {
			const p:Point = new Point(stage.mouseX, stage.mouseY);
			var d:int = Geom.CENTER_COOR_8.direction(p);
			var a:int, x:int, y:int;
			if (move && scene.structMask) {
				a = Geom.CENTER_COOR_8.area(p);
				x = scene.X + Geom.DIRECTION_DELTA_X[d];
				y = scene.Y + Geom.DIRECTION_DELTA_Y[d];
				if (scene.structMask.m1(x, y)) {
					d = (a === d ? Geom.CENTER_COOR_8.nexts : Geom.CENTER_COOR_8.lasts)[d];
					x = scene.X + Geom.DIRECTION_DELTA_X[d];
					y = scene.Y + Geom.DIRECTION_DELTA_Y[d];
					if (scene.structMask.m1(x, y)) {
						d = -1;
					}
				}
			}
			return d;
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
			const d:int = hero.direction;
			switch (motion) {
				case Hero.MOTION_WALK:
					stepX = Geom.WALK_DIRECTIONS_X_DELTA[d];
					stepY = Geom.WALK_DIRECTIONS_Y_DELTA[d];
					if (scene) {
						if (Geom.DIRECTION_DELTA_Y[d] > 0) {  // fuck
							scene.placeRow(hero, scene.Y + Geom.DIRECTION_DELTA_Y[d])
						}
						scene.X += Geom.DIRECTION_DELTA_X[d];
						scene.Y += Geom.DIRECTION_DELTA_Y[d];
					}
					break;
				case Hero.MOTION_RUN:
					stepX = Geom.RUN_DIRECTIONS_X_DELTA[d];
					stepY = Geom.RUN_DIRECTIONS_Y_DELTA[d];
					if (scene) {
						if (Geom.DIRECTION_DELTA_Y[d] > 0) {
							scene.placeRow(hero, scene.Y + Geom.DIRECTION_DELTA_Y[d] * 2)
						}
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

		private function motionDoing(e:Event):void {
			const motion:int = hero.motion;
			const move:Boolean = (motion === Hero.MOTION_WALK || motion === Hero.MOTION_RUN);
			const n:int = hero.aniIdx;
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
			if (motion === Role.MOTION_DEFAULT) {
				act();
			}
		}

		public function act():void {
			const motion:int = states.lastIndexOf(true);
			if (motion === Role.MOTION_DEFAULT) {
				return
			}
			const d:int = dir(motion === Hero.MOTION_WALK || motion === Hero.MOTION_RUN)
			if (d >= 0) {
				timer.delay = DELAIES[motion];
				const slowDown:Boolean = (motion === Hero.MOTION_RUN) && scene.structMask.m1(scene.X + Geom.DIRECTION_DELTA_X[d] * 2, scene.Y + Geom.DIRECTION_DELTA_Y[d] * 2);
				hero.motion = slowDown ? Hero.MOTION_WALK : motion;
				hero.direction = d;
			}
		}

		private function motionEnded(e:Event):void {
			timer.stop();
			if (scene) {
				scene.place(hero, scene.X, scene.Y);
				scene.update();
			}
			act();
//			trace(scene.X, scene.Y);
            timer.start();  // can also do not start and block
		}

	}
}
