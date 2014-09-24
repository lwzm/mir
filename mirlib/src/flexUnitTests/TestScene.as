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
			assertEquals(
				(Const.TILES_COUNT_LEFT + Const.TILES_COUNT_RIGHT)
				* (Const.TILES_COUNT_UP + Const.TILES_COUNT_DOWN)
				* 1.25  // big-tiles(.25) and small-tiles(1)
				+ (Const.TILES_COUNT_UP + Const.TILES_COUNT_DOWN)  // rows
				+ (Const.TILES_COUNT_UP + Const.TILES_COUNT_DOWN)  // hitRows
				+ 1  // shadows
				,
				scene.numChildren);
		}
		
		[Test]
		public function testPlace():void {
		}
	}
}