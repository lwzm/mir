package
{
	import Array;
	
	import flash.display.Sprite;
	
	import flexunit.flexui.FlexUnitTestRunnerUIAS;
	
	import mir.flexUnitTests.TestConst;
	import mir.flexUnitTests.TestHero;
	import mir.flexUnitTests.TestRes;
	import mir.flexUnitTests.TestScene;
	import mir.flexUnitTests.TestUtils;
	
	public class FlexUnitApplication extends Sprite
	{
		public function FlexUnitApplication()
		{
			onCreationComplete();
		}
		
		private function onCreationComplete():void
		{
			var testRunner:FlexUnitTestRunnerUIAS=new FlexUnitTestRunnerUIAS();
			testRunner.portNumber=8765; 
			this.addChild(testRunner); 
			testRunner.runWithFlexUnit4Runner(currentRunTestSuite(), "mirlib");
		}
		
		public function currentRunTestSuite():Array
		{
			var testsToRun:Array = new Array();
			testsToRun.push(mir.flexUnitTests.TestConst);
			testsToRun.push(mir.flexUnitTests.TestHero);
			testsToRun.push(mir.flexUnitTests.TestRes);
			testsToRun.push(mir.flexUnitTests.TestScene);
			testsToRun.push(mir.flexUnitTests.TestUtils);
			return testsToRun;
		}
	}
}