package  {

	import flexunit.framework.TestCase;
	import net.humanrender.helpers.ValidationHelper;
	
	public class ValidationHelperTest extends TestCase{
		
		public function ValidationHelperTest(method:String = null) {
			super(method);
		}
		
		public function isEmailTest():void {
			assertTrue(ValidationHelper.isEmail("myemail@host.com"))
			assertTrue(ValidationHelper.isEmail("my_email?@host.com"))
			assertTrue(ValidationHelper.isEmail("my.e~mail@host.com"))
			assertTrue(ValidationHelper.isEmail("my_email@host.com.es"))
			
			assertFalse(ValidationHelper.isEmail("my_email@host.com.es."));
			assertFalse(ValidationHelper.isEmail(".my_email@host.com"));
			assertFalse(ValidationHelper.isEmail("my_email.host.com"));
			assertFalse(ValidationHelper.isEmail("my_email.@host.com"));
			assertFalse(ValidationHelper.isEmail("my_email..123@host.com"));
			assertFalse(ValidationHelper.isEmail("my@e@mail@host.com"));
			assertFalse(ValidationHelper.isEmail("@host.com"));
			assertFalse(ValidationHelper.isEmail("()[]\;:,<>@host.com"));
			
		}
		
	}

}