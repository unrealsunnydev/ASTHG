package backend;

class Constants {
	// Fonts
	public static final ABSOLUTE_FONT_GLYPHDATA:String = [ // Switched to array for more organization
		" ☺☻♥♦♣♠●◘◉◙♂♀♪♬☼",
		"►◄↕‼¶§▄↨↑↓→←∟↔▲▼",
		" !\"#$%&'()*+,-./",
		"0123456789:;<=>?",
		"@ABCDEFGHIJKLMNO",
		"PQRSTUVWXYZ[\\]^_",
		"`abcdefghijklmno",
		"pqrstuvwxyz{|}~⌂",
		"ÇüéâäaçêëèïîìÄÂ",
		"ÉæÆôöòûùÿÖÜc¢£¥₧ƒ",
		"áíóúñÑªº¿⌐¬½¼¡«»"
	].join("");

	// Characters
	public static final PALETTE_OVERRIDE:Array<FlxColor> = [0xFF2020A0, 0xFF2040C0, 0xff4040E0, 0xff6060E0];

	// Save Select
	public static final SAVE_ENTRY_LIMIT:Int = 7;
	public static final SAVE_SELECTED_FRAME_COLOR:Array<FlxColor> = [0xffffffff, 0xffff0000];
	public static final SAVE_SELECTED_ARROW_COLOR:Array<FlxColor> = [0xffff0059, 0xffff0059];


	public static final POLYMOD_SETTINGS:Dynamic = {
		dirs:["pt-BR Translation"],
		useScriptedClasses: false
	};

	// Files
	inline public static var SOUND_EXT = #if (web || flash) "mp3" #else "ogg" #end;
	inline public static var VIDEO_EXT = "mp4";
}

enum abstract ConstantSound(String) to String {
	var MENU_ACCEPT = "MenuAccept";
	var MENU_SCROLL = "MenuChange";
	var MENU_BACK   = "MenuCancel";

	var PLAYER_JUMP = "Jump";
}