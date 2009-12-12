package net.humanrender.helpers {
	
	/* String Helper */
	
	public class StringHelper {
		
		public static function trim(word:String):String{
			var regexp:RegExp = /^\s*(.+?)(?=\s*$)/; 
			var trimedResult:Object = regexp.exec(word);
			return trimedResult ? trimedResult[1].toString() : word;
		}
		
		public static function isWhite(string:String):Boolean {
			var regexp:RegExp = /\S/g;
			return !regexp.exec(string);
		}
		
		public static function parameterize(string:String, separator:String = "_"):String {
			return string.toLowerCase().replace( /[^\s\w]/g ,  "" ).replace( /\s+/g , separator );
		}
		
		public static function humanize(string:String, ...separators):String {
			var stringedSeparators:String = separators.length != 0 ? separators.join("|") : "_";
			var regexp:RegExp = new RegExp("(" + stringedSeparators + ")", "g");
			return firstToUpper(string.replace(regexp, " "));
		}
		
		public static function firstToUpper(string:String):String {
			return replaceFirst(string, function(firstChar:String):String {
				return firstChar.toUpperCase();
			})
		}
		
		public static function firstToLower(string:String):String {
			return replaceFirst(string, function(firstChar:String):String {
				return firstChar.toLowerCase();
			})
		}
		
		public static function replaceFirst(string:String, options:*):String {
			var replaceWith:* = !(options is Function) ? options.toString() : function():String {
				var firstChar:String = arguments[0]; if (!firstChar) firstChar = "";
				return options(firstChar);
			};
			string = string.replace(/^\w/, replaceWith);
			return string
		}
		
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