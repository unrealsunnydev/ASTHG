package tools;

import sys.io.File;
import sys.FileSystem;

using StringTools;

class Language {
	static var trans:Map<String, String> = []; // Store translations here
	static var curLang:String = lime.system.Locale.currentLocale;

	public static function load() {
		curLang ??= "en_US";
		
		if (!FileSystem.exists('_project/translations/$curLang.txt')) {
			curLang = "en_US";
		}

		var file = File.getContent("_project/translations/" + curLang + ".txt");

		for (line => text in file.split("\n")) {
			text = text.trim();

			if (text.length > 4) {
			var parts = text.split("=");
				trans.set(parts[0], parts[1]);
			}
		}
	}

	inline public static function translate(key:String, ?replaces:Array<Dynamic>):String {
		var str = trans.get(key);
		str ??= key;

		if (replaces != null) {
			for (num => i in replaces) {
				str = str.replace('{$num}', i);
			}
		}

		str = str.replace("\\n", "\n")
			.replace("\\t", "\t")
			.replace("\\r", "\r");

		return str;
	}
}