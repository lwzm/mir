package flexUnitTests
{
	import flexunit.framework.Assert;
	
	import mir.Const;
	import mir.Scene;
	
	import org.flexunit.asserts.assertEquals;
	
	public class TestScene
	{		
		private var scene:Scene;

		[Before]
		public function setUp():void {
			scene = new Scene("0");
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
		public function testLoop():void {
			assertEquals(Const.TILES_COUNT_RIGHT * Const.TILES_COUNT_DOWN * 1.25 + Const.TILES_COUNT_DOWN, scene.sprite.numChildren);
		}
		
		[Test]
		public function testMove():void {
			assertEquals(6, scene.move(1, 1).length);
		}
		
		[Test]
		public function testPlace():void {
		}
		
		[Test]
		public function testGet_x():void {
		}
		
		[Test]
		public function testSet_x():void {
		}
		
		[Test]
		public function testGet_y():void {
		}
		
		[Test]
		public function testSet_y():void {
		}
	}
}