package flexUnitTests
{
	
	import flash.events.IOErrorEvent;
	import flash.text.TextField;
	
	import mir.Const;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	
	public class TestConst
	{		
		[Before]
		public function setUp():void
		{
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
		public function testConst():void {
			assertEquals(Const.SCREEN_W, 800);
		}
		
		[Test]
		public function testConst_pallet():void {
			assertEquals(Const.PALLET.length, 256);
			assertEquals(Const.PALLET[0], 0);
			assertEquals(Const.PALLET[255], 0xffffffff);
			for (var i:Object in Const.PALLET) {
				assertNotNull(Const.PALLET[i] as uint);
			}
		}
		
	}
}