package mir.flexUnitTests
{
	import flexunit.framework.Assert;
	
	import mir.Const;
	import mir.Hero;
	import mir.Role;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertStrictlyEquals;
	import org.flexunit.async.Async;
	
	public class TestHero
	{		
		private var hero:Hero;

		[Before]
		public function setUp():void {
			hero = new Hero();
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testAddFilter():void {
			hero.addFilter("red"); hero.addFilter("red"); hero.addFilter("red");
			assertEquals(1, hero.filters.length, hero.shadow.filters.length);
			hero.addFilter("green");
			hero.addFilter("blue");
			assertEquals(3, hero.filters.length, hero.shadow.filters.length);
		}
		
		[Test]
		public function testDelFilter():void {
			hero.addFilter("red");
			hero.addFilter("green");
			hero.addFilter("blue");
			assertEquals(3, hero.filters.length, hero.shadow.filters.length);
			hero.delFilter("green");
			assertEquals(2, hero.filters.length, hero.shadow.filters.length);
			hero.delFilter("blue");
			assertEquals(1, hero.filters.length, hero.shadow.filters.length);
			hero.delFilter("red"); hero.delFilter("red");
			assertEquals(0, hero.filters.length, hero.shadow.filters.length);
		}
		
		[Test(async)]
		public function testMOTION_DEFAULT():void {
			assertEquals(Role.MOTION_DEFAULT, hero.motion);
			Async.delayCall(this, function():void {
				assertEquals(Role.MOTION_DEFAULT, hero.motion);
			}, Math.random() * 1000);
		}

		[Test]
		public function testSet_motion():void {
			return
			hero.motion = Hero.MOTION_WALK;
			assertEquals(hero.motion, Role.MOTION_DEFAULT);
			hero.ani();
			assertEquals(hero.motion, Hero.MOTION_WALK);
//			while (!hero.ended) {
//				hero.ani();
//			}
			assertEquals(hero.motion, Hero.MOTION_WALK);
			hero.ani();
			assertEquals(hero.motion, Role.MOTION_DEFAULT);
		}

		[Test]
		public function test_motionBreak():void {
			hero.ani();
			hero.ani();
			hero.motion = Hero.MOTION_WALK;
			hero.ani();
			assertEquals(hero.motion, Hero.MOTION_WALK);
			hero.ani();
			hero.motion = Hero.MOTION_RUN;
			hero.ani();
			assertEquals(hero.motion, Hero.MOTION_WALK);
			return
//			while (!hero.ended) {
//				hero.ani();
//			}
			hero.ani();
			assertEquals(hero.motion, Hero.MOTION_RUN);
		}
		
		[Test(async)]
		public function testSwitchLayer():void {
			var weaponLayer:* = hero.getChildAt(0);
			hero.direction = 1;
			hero.motion = 0;
		}

		[Test]
		public function testSet_body():void {
		}
		
		[Test]
		public function testSet_hook0():void {
		}

		[Test]
		public function testSet_x():void {
			var n:Number = 100;
			hero.x = n;
			assertEquals(n, hero.x, hero.shadow.x, hero.hitArea.x);
		}
		
		[Test]
		public function testSet_y():void {
			var n:Number = 100;
			hero.y = n;
			assertEquals(n, hero.y, hero.shadow.y, hero.hitArea.y);
		}
	}
}