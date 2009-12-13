package net.humanrender.helpers {
	
	public class ValidationHelper{
		
		
		/**
		 * Validates if an email is valid.
		 * @param	email
		 * @return true if email is valid else, returns false
		 */
		public static function isEmail(email:String):Boolean {
			return /^[^\.]([A-z0-9!#$%&'*+-\/=?^_`{|}~.](?!\.{2}))+[^.]@[^.]\w+\.[\w.]+[^.]$/.exec(email);
		}
		
	}

}