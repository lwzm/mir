package mir.flexUnitTests
{
	
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mir.Const;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.async.Async;
	
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
		
		[Test(async)]
		public function testConst():void {
			assertEquals(Const.SCREEN_W, 800);
			var delay:Number = 10;
			Async.delayCall(this, testDelayCall, delay);
			var timer:Timer = new Timer(delay);
			timer.addEventListener(TimerEvent.TIMER, Async.asyncHandler(this, testAsync, delay + 1));
			timer.start();
		}

		private function testDelayCall():void {  // just try
			assertEquals(Const.SCREEN_H, 600);
		}
		
		private function testAsync(e:TimerEvent, o:Object):void {  // just try asynchronous testing
			assertEquals(Const.SCREEN_H, 600);
		}
		
		[Test]
		public function testConstPALLET():void {
			assertEquals(Const.PALLET.length, 256);
			assertEquals(Const.PALLET[0], 0);
			assertEquals(Const.PALLET[255], 0xffffffff);
			for (var i:Object in Const.PALLET) {
				assertNotNull(Const.PALLET[i] as uint);
			}
		}
		
	}
}