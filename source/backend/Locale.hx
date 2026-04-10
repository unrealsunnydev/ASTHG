package backend;

import firetongue.FireTongue;

using util.StringUtil;

/**
	Handler for translating text and assets in the game

	### Functions
	`getString`, `getFile`
 */
class Locale {

	/**
		Gets an translation phrase
		@param key String key on files
		@param defaultPhrase Phrase in English
		@param values Any phrase that has "`{1}`, `{2}`..." will be replaced with any value inserted following a sequence
		@return String
	**/
	inline public static function getString(key:String, context:String = "data", ?values:Array<Dynamic> = null):String {
		var str:String = Main.tongue.get(formatKey(key), context, true);

		if (values != null)
			str.format(values);

		return str;
	}

	/**
		Gets a translatable file, More optimized for file loading
		@param key Default file path
		@param extension File extension to add ("txt", "png"...), "." will be added automatically
		@return String
		@authorTip Sunnydev31
	**/
	inline public static function getFile(key:String, ?extension:String = "") {
		var str:String = Main.tongue.get(key.trim(), "files");
		if (!StringUtil.isNull(str)) key = str;

		if (!StringUtil.isNull(extension))
			key += '.$extension';
		
		return key;
	}

	inline static private function formatKey(key:String) {
		final hideChars = ~/[~&\\\/;:<>#.,'"%?!]/g;
		return hideChars.replace(key.replace(' ', '_'), '').trim().toLowerCase();
	}
}