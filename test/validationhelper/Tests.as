package {
	
	import flash.display.Sprite;
	import flexunit.textui.TestRunner;
	import flexunit.framework.TestListener;
	import flexunit.framework.TestResult;
	import flexunit.textui.ResultPrinter;
	import flexunit.framework.TestSuite;
	import src.ValidationHelperTest;
	
	public class Tests  extends Sprite{
		
		private var result:TestResult;
		
		public function Tests() {
			super();
			
			var suite:TestSuite = new TestSuite()
			suite.addTest(new ValidationHelperTest("isEmailTest"));
			
			this.result = TestRunner.run(suite,onTestEnded);
	
		}
		
		private function onTestEnded():void {
			
		}
		
	}

}