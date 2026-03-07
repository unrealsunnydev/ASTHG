package util;

/**
	Contains tools for string manipulation and formatting
**/
class StringUtil {
	
	inline public static function capitalize(text:String)
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();
	
	/**
		Checks if `string` is `null` or empty

		@param string The string to check
		@return Bool
	**/
	inline public static function isNull(string:Null<String>):Bool
		return (string == null || string.trim().length <= 0);
}