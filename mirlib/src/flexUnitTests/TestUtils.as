package flexUnitTests
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.utils.ByteArray;
	
	import mir.Utils;
	
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertNull;
	import org.flexunit.asserts.assertTrue;
	
	public class TestUtils
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
		public function test_loadAsset():void {
			Utils.loadDeflatedBinary("http://tmp.qww.pw/bodies/00", function(bytes:ByteArray):void {
				assertTrue(bytes.length > 0);
			});
//			Utils.loadDeflatedBinary("http://tmp.qww.pw/not_exist", function(bytes:ByteArray):void {
//				trace("loaded");
//			});
		}
		
		[Test]
		public function test_trim():void {
			assertEquals("s", Utils.trim(" s  "));
		}

		[Test]
		public function test_range():void {
			var arr:Array;
			arr = Utils.range(0, 10);
			assertEquals(11, arr.length);
			assertEquals(10, arr[arr.length - 1]);
			arr = Utils.range(0.2, 0, -0.1);
			assertEquals(3, arr.length);
		}

		[Test]
		public function test_loadBitmaps():void {
//			Utils.loadMirBitmaps("http://mir.qww.pw/bodies/00", function(x):void{});
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
//			bytes.writeByte(1);
			bytes.deflate(); bytes.inflate();  // or bytes.position = 0;
			var bmps:Array = Utils.bytesToMirBitmaps(bytes);
//			assertEquals(bmps.blendMode, BlendMode.ADD);
			assertEquals(bmps[0].width, w);
			assertEquals(bmps[0].height, h);
			assertEquals(bmps[0].x, x);
			assertEquals(bmps[0].y, y);
		}
	}
}