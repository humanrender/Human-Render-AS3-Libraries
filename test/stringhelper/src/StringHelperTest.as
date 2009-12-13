package  {

	import flexunit.framework.TestCase;
	import net.humanrender.helpers.StringHelper;
	
	public class StringHelperTest extends TestCase{
		
		public function StringHelperTest(method:String = null) {
			super(method);
		}
		
		public function trimTest():void {
			var string:String = " Hello ";
			assertEquals("Hello", StringHelper.trim(string));
			
			string = "				Hello					      ";
			assertEquals("Hello", StringHelper.trim(string));
			
			string = (<![CDATA[
			
								Hello 
			
			]]>).toString();
			assertEquals("Hello", StringHelper.trim(string));
		}
		
		public function emptyTest():void {
			var string:String = "";
			assertTrue(StringHelper.isEmpty(string));
			
			string = " "
			assertTrue(StringHelper.isEmpty(string));
			
			string = "			   "
			assertTrue(StringHelper.isEmpty(string));
			
			string = (<![CDATA[
			
			         
			
			]]>).toString();
			assertTrue(StringHelper.isEmpty(string));
		}
		
		public function parameterizeTest():void {
			var string:String = "post #1: The quick brown fox jumps over the lazy dog?"
			assertEquals("post_1_the_quick_brown_fox_jumps_over_the_lazy_dog", StringHelper.parameterize(string));
		}
		
		public function humanizeTest():void {
			var string:String = "post_1_the_quick_brown_fox_jumps_over_the_lazy_dog"
			assertEquals(StringHelper.humanize(string), "Post 1 the quick brown fox jumps over the lazy dog");
			string = "post-1_the/quick-brown_fox/jumps-over_the/lazy-dog"
			assertEquals(StringHelper.humanize(string, "-", "_", "/"), "Post 1 the quick brown fox jumps over the lazy dog");
		}
		
		public function firstToUpperTest():void {
			var string:String = "hello";
			assertEquals("Hello", StringHelper.firstToUpper(string));
			string = "\thello"
			assertEquals("\tHello",StringHelper.firstToUpper(string));
		}
		
		public function firstToLowerTest():void {
			var string:String = "Hello";
			assertEquals("hello", StringHelper.firstToLower(string));
			string = "\tHello"
			assertEquals("\thello",StringHelper.firstToLower(string));
		}
		
		public function replaceFirstTest():void {
			var string:String = "item 01";
			assertEquals( "otem 01", StringHelper.replaceFirst(string,"o"));
			assertEquals("01.- Item 01",StringHelper.replaceFirst(string,function(firstChar:String):String{
				return "01.- " + firstChar.toUpperCase();
			}))
			string = "	item 01"
			assertEquals("otem 01", StringHelper.replaceFirst(string,"o") )
		}
		
		public function titleCaseTest():void {
			var string:String = "The quick brown fox jumps over the lazy dog"
			assertEquals(StringHelper.toTitleCase(string), "The Quick Brown Fox Jumps Over The Lazy Dog");
		}
		
	}

}