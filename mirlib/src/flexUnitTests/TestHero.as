package flexUnitTests
{
	import flexunit.framework.Assert;
	
	import mir.Const;
	import mir.Hero;
	
	import org.flexunit.asserts.assertEquals;
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
			assertEquals(Hero.MOTION_DEFAULT, hero.motion);
			Async.delayCall(this, function():void {
				assertEquals(Hero.MOTION_DEFAULT, hero.motion);
			}, Math.random() * 1000);
		}

		[Test(async)]
		public function testSet_motion():void {
			var motion1:int = 1, motion2:int = 2;
			hero.motion = motion1;
			hero.motion = motion2;
			assertEquals(motion1, hero.motion);
		}
		
		[Test(async)]
		public function testTuneXY_1():void {
			var motion1:int = 1, motion2:int = 2;
			var hero0:Hero = new Hero();
			var hero1:Hero = new Hero();
			var hero2:Hero = new Hero();
			var hero3:Hero = new Hero();
			var hero4:Hero = new Hero();
			var hero5:Hero = new Hero();
			var hero6:Hero = new Hero();
			var hero7:Hero = new Hero();
			hero0.direction = 0;
			hero1.direction = 1;
			hero2.direction = 2;
			hero3.direction = 3;
			hero4.direction = 4;
			hero5.direction = 5;
			hero6.direction = 6;
			hero7.direction = 7;
			hero0.motion = hero1.motion = hero2.motion = hero3.motion = hero4.motion = hero5.motion = hero6.motion = hero7.motion = motion1;
			var delay:Number = 1000;
			Async.delayCall(this, function():void {
				assertEquals(0, hero0.x);
				assertEquals(-Const.TILE_H, hero0.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(Const.TILE_W, hero1.x);
				assertEquals(-Const.TILE_H, hero1.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(Const.TILE_W, hero2.x);
				assertEquals(0, hero2.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(Const.TILE_W, hero3.x);
				assertEquals(Const.TILE_H, hero3.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(0, hero4.x);
				assertEquals(Const.TILE_H, hero4.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(-Const.TILE_W, hero5.x);
				assertEquals(Const.TILE_H, hero5.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(-Const.TILE_W, hero6.x);
				assertEquals(0, hero6.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(-Const.TILE_W, hero7.x);
				assertEquals(-Const.TILE_H, hero7.y);
			}, delay);
		}

		[Test(async)]
		public function testTuneXY_2():void {
			var motion1:int = 1, motion2:int = 2;
			var hero0:Hero = new Hero();
			var hero1:Hero = new Hero();
			var hero2:Hero = new Hero();
			var hero3:Hero = new Hero();
			var hero4:Hero = new Hero();
			var hero5:Hero = new Hero();
			var hero6:Hero = new Hero();
			var hero7:Hero = new Hero();
			hero0.direction = 0;
			hero1.direction = 1;
			hero2.direction = 2;
			hero3.direction = 3;
			hero4.direction = 4;
			hero5.direction = 5;
			hero6.direction = 6;
			hero7.direction = 7;
			hero0.motion = hero1.motion = hero2.motion = hero3.motion = hero4.motion = hero5.motion = hero6.motion = hero7.motion = motion2;
			var delay:Number = 1000;
			Async.delayCall(this, function():void {
				assertEquals(0, hero0.x);
				assertEquals(-Const.TILE_H * 2, hero0.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(Const.TILE_W * 2, hero1.x);
				assertEquals(-Const.TILE_H * 2, hero1.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(Const.TILE_W * 2, hero2.x);
				assertEquals(0, hero2.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(Const.TILE_W * 2, hero3.x);
				assertEquals(Const.TILE_H * 2, hero3.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(0, hero4.x);
				assertEquals(Const.TILE_H * 2, hero4.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(-Const.TILE_W * 2, hero5.x);
				assertEquals(Const.TILE_H * 2, hero5.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(-Const.TILE_W * 2, hero6.x);
				assertEquals(0, hero6.y);
			}, delay);
			Async.delayCall(this, function():void {
				assertEquals(-Const.TILE_W * 2, hero7.x);
				assertEquals(-Const.TILE_H * 2, hero7.y);
			}, delay);
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