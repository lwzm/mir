package flexUnitTests
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.ByteArray;
	
	import mir.Const;
	import mir.Util;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	
	public class TestUtils
	{		
		private static const TIME_OUT:Number = 2000;

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
		public function test_loadAsset():void {
			var s:String;
			var test:Function = Async.asyncHandler(this, function(e:Event, o:Object):void {
				assertTrue(s.length > 0);
			}, TIME_OUT);
			Util.loadString(Const.ASSETS_DOMAIN + "crossdomain.xml", function(str:String):void {
				s = str;
				test(null);
			});
		}
		
		[Test]
		public function test_trim():void {
			assertEquals("s", Util.trim(" s  "));
		}

		[Test]
		public function test_loadBitmaps():void {
//			Utils.loadMirBitmaps("http://mir.qww.pw/../../data/bodies/00", function(x):void{});
		}

		[Test]
		public function test_loadMirBitmaps():void {
			var bytes:ByteArray = new ByteArray();
			var repeat:int = 10;
			var w:int = 4;
			var h:int = 5;
			var x:int = 1000;
			var y:int = -1000;
			assertEquals(w % 4, 0);
			while (repeat--) {
				bytes.writeShort(w);
				bytes.writeShort(h);
				bytes.writeShort(x);
				bytes.writeShort(y);
				for (var i:int = 0; i < w * h; i++) {
					bytes.writeByte(repeat);
				}
			}
			bytes.deflate(); bytes.inflate();  // or bytes.position = 0;
			var bmps:Array = Util.bytesToMirBitmaps(bytes);
			assertEquals(bmps[0].width, w);
			assertEquals(bmps[0].height, h);
			assertEquals(bmps[0].x, x);
			assertEquals(bmps[0].y, y);
		}
	}
}