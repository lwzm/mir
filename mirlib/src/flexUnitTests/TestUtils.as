package flexUnitTests
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	import mir.MirBmp;
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
			Utils.loadAsset("http://lwzgit.duapp.com/bodies/00", function(bytes:ByteArray):void {
				assertTrue(bytes.length > 0);
			});
		}
		
		[Test]
		public function test_trim():void {
			assertEquals("s", Utils.trim(" s  "));
		}

		[Test]
		public function test_loadBitmaps():void {
			Utils.loadMirBmps("http://lwzgit.duapp.com/bodies/00", function(x){});
			Utils.loadMirBmp("http://lwzgit.duapp.com/bodies/00", function(x){});
		}

		[Test]
		public function test_extractMirBmp():void {
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
			var mir_bmp:MirBmp;
			mir_bmp = Utils.extractMirBmp(bytes);
			assertNull(mir_bmp.shadow);  // normal
			assertEquals(mir_bmp.bitmap.width, w);
			assertEquals(mir_bmp.bitmap.height, h);
			assertEquals(mir_bmp.x, x);
			assertEquals(mir_bmp.y, y);
			mir_bmp = Utils.extractMirBmp(bytes, true);  // with shadow
			assertNotNull(mir_bmp.shadow);
			assertEquals(mir_bmp.bitmap.width, w);
			assertEquals(mir_bmp.bitmap.height, h);
			assertEquals(mir_bmp.shadow.width, w);
			assertEquals(mir_bmp.shadow.height, h);
			assertEquals(mir_bmp.x, x);
			assertEquals(mir_bmp.y, y);
			// ...
		}
	}
}