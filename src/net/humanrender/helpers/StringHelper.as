package net.humanrender.helpers {
	
	/* String Helper */
	
	public class StringHelper {
		
		
		/**
		 * Removes leading and trailing whitespace from a string
		 * @param	string
		 * @return	The string stripped of  leading and trailing whitespace
		 * @example
		 * <listing version="3.0">
		 * var string:String = "	Hello			"
		 * StringHelper.trim(string) // "Hello"
		 * </listing>
		 */
		public static function trim(string:String):String {
			return string.replace(/^\s+|\s+$/g, "");
			/*var regexp:RegExp = /^\s*(.+?)(?=\s*$)/; 
			var trimedResult:Object = regexp.exec(word);
			return trimedResult ? trimedResult[1].toString() : word;*/
		}
		
		
		/**
		 * Returns true if the string consists only of whitespace characters, otherwise return false
		 * @param	string
		 * @return true if the string consists only of whitespace characters, otherwise return false
		 */
		public static function isEmpty(string:String):Boolean {
			var regexp:RegExp = /\S/g;
			return !regexp.exec(string);
		}
		
		
		/**
		 * Returns a copy of string with special characters, whitespace characters replaced with a separator and lowercased
		 * @param	string	The string to be parameterized
		 * @param	separator	The separator to be inserted between words. By default is an underscore
		 * @return	A copy of string with special characters, whitespace characters replaced with a separator and lowercased
		 * @example
		 * <listing version="3.0">
		 * var string:String = "post #1: The quick brown fox jumps over the lazy dog?"
		 * StringHelper.parameterize(string) // "post1_the_quick_brown_fox_jumps_over_the_lazy_dog"
		 * </listing>
		 */
		public static function parameterize(string:String, separator:String = "_"):String {
			return string.toLowerCase().replace( /[^\s\w]/g ,  "" ).replace( /\s+/g , separator );
		}
		
		/**
		 * Returns a copy of string with a separator or list of separators replaced by whitespace and the first letter title cased
		 * @param	string
		 * @param	...separators	default is underscore ( "_" )
		 * @return  A copy of string with a separator or list of separators replaced by whitespace and the first letter title cased
		 */
		public static function humanize(string:String, ...separators):String {
			var stringedSeparators:String = separators.length != 0 ? separators.join("|") : "_";
			var regexp:RegExp = new RegExp("(" + stringedSeparators + ")", "g");
			return firstToUpper(string.replace(regexp, " "));
		}
		
		/**
		 * Returns a copy of the string with the first letter uppercased
		 * @param	string
		 * @return A copy of the string with the first letter uppercased
		 */
		public static function firstToUpper(string:String):String {
			return replaceFirst(string, function(firstChar:String):String {
				return firstChar.toUpperCase();
			})
		}
		
		/**
		 * Returns a copy of the string with the first letter lowercased
		 * @param	string
		 * @return A copy of the string with the first letter lowercased
		 */
		public static function firstToLower(string:String):String {
			return replaceFirst(string, function(firstChar:String):String {
				return firstChar.toLowerCase();
			})
		}
		
		/**
		 * Replace the first character of a string. If a string is passed as the options, the first character is replaced by the string. Otherwise if options is a function the first character is replaced by the result of the function.
		 * @param	string
		 * @param	options	Either a String or a function that receives the first character as argument
		 * @return	A copy of the string with the first character removed either by a String or by the execution of a function that receives the first character as argument
		 * @example
		 * <listing version="3.0">
		 * var string:String = "item 01";
		 * StringHelper.replaceFirst(string,"o"); // "otem 01"
		 * StringHelper.replaceFirst(string,function(firstChar:String):String{
		 * 	trace(firstChar) // i
		 * 	return "01.- " + firstChar.toUpperCase();
		 * }); // "01.- Item 01"
		 * </listing>
		 */
		public static function replaceFirst(string:String, options:*):String {
			var replaceWith:* = !(options is Function) ? options.toString() : function():String {
				var firstChar:String = arguments[0]; if (!firstChar) firstChar = "";
				return options(firstChar);
			};
			string = string.replace(/^\w/, replaceWith);
			return string
		}
		
		/**
		 * Returns a copy of a string with the first character of each word uppercased
		 * @param	string
		 * @return A copy of a string with the first character of each word uppercased
		 * @example
		 * <listing version="3.0">
		 * var string:String = "The quick brown fox jumps over the lazy dog"
		 * StringHelper.toTitleCase(string) // "The Quick Brown Fox Jumps Over The Lazy Dog"
		 * </listing>
		 */
		public static function toTitleCase(string:String):String {
			var regexp:RegExp = /\w+/g;  
			var match:Object = regexp.exec(string);
			while (match != null) {
				var stringedMatch:String = match.toString();
				string = string.replace(stringedMatch,firstToUpper(stringedMatch))
				match = regexp.exec(string);
			 }	
			 return string;
		}
		
	}

}