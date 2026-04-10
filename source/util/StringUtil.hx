package util;

#if flixel // Maybe I can import this on lime...
import flixel.util.FlxStringUtil;
#end

using StringTools;

/**
	Contains tools for string manipulation and formatting
**/
class StringUtil {
	inline public static function capitalize(text:String):String
		return text.charAt(0).toUpperCase() + text.substr(1).toLowerCase();

	/**
		Checks if `string` is `null` or empty

		@param string The string to check
		@return Bool
		@author unreal.sunnydev
	**/
	inline public static function isNull(str:Null<String>):Bool
		#if cs
		// C# function is more powerful here, and we check both
		// because this is what this function does
		return untyped (String.isNullOrEmpty(str) || String.isNullOrWhiteSpace(str));
		#else
		return (str == null || str?.trim()?.length <= 0); // Depending on target, we can get -1
		#end

	/**
		Formats the string allowing to use placeholders in it
		.NET Styled

		Placeholder format: {index} OR {index:modifier[X|C (flixel)]}
		e.g.: {0:X} -> Placeholder Index 0, Modifier Int to Hex

		@param str	The string to format
		@param values If a placeholder is found, replace them with the value in this parameter
		@return Bool
		@author unreal.sunnydev31
	**/
	inline public static function format(str:String, values:Null<Array<Dynamic>>):String {
		// HOLY SHIT, I LOVED MAKING THIS FUNCTIONAL!!! YAAYY!

		#if cs
		return untyped String.Format(str, values);
		#else
		var temp = str;

		if (isNull(temp))
			throw "The String is empty to format it!";

		if (values != null && values.length > 0) {
			for (num => val in values) {
				if (isNull(val))
					throw 'Value #$num is null. Format will not have any effects on string';

				/**
					Placeholder captures to format
					Style: `(Int / Word)?`:`(Hex / Currency)?`
				**/
				var regMods:Array<String> = ["X\\d+?"];
				#if flixel regMods.push("C"); #end

				var reg:EReg = new EReg('\\{($num)(?::(${regMods.join("|")}))?\\}', "i");

				if (reg.match(temp)) {
					if (reg.matchedLeft() == "{" && reg.matchedRight() == "}")
						break;

					var modifier = val;

					var matched2 = reg.matched(2); // Performing cache
					if (matched2 != null && matched2 != "") {
						// If a modifier is found, format the string
						var modifier = switch (matched2) {
							case "X":
								StringTools.hex(val, (!isNull(matched2) && matched2.length > 1) ? Std.parseInt(matched2.substring(1)) : 1); // Number Hex
							#if flixel
							case "C": FlxStringUtil.formatMoney(Std.parseInt(val)); // Currency
							#end
							default: val; // Default: No formating
						}

						temp = temp.replace(reg.matched(0), Std.string(modifier));
					} else {
						temp = temp.replace(reg.matched(0), Std.string(val));
					}
				}
			}
		}
		else {
			throw "`values` parameter is null or empty! Did you forget to insert a value in here?";
		}

		return temp;
		#end
	}
}
