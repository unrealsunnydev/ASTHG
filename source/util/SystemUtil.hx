package util;

class SystemUtil {
	inline public static function openFolder(folder:String, absolute:Bool = false) {
		#if sys
		if(!absolute) folder =  Sys.getCwd() + folder;

		folder = folder.replace('/', '\\');
		if(folder.endsWith('/')) folder.substr(0, folder.length - 1); 

		#if linux
			var command:String = '/usr/bin/xdg-open';
		#elseif windows
			var command:String = 'explorer.exe';
		#end

		#if (windows || linux)
			Sys.command(command, [folder]);
			trace('[openFolder] $command $folder');
		#end
		#else
		FlxG.log.error("Platform is not supported for SystemUtil.openFolder");
		#end
	}

	inline public static function browserLoad(site:String):Void {
		#if linux
		Sys.command('/usr/bin/xdg-open', [site]);
		#else
		FlxG.openURL(site);
		#end
	}

	@:privateAcess()
	private static var _accent:FlxColor = FlxColor.WHITE;
	public static var ACCENT_COLOR(get, set):FlxColor;
	inline public static function loadAccentColor():Null<FlxColor> {
		#if (windows && !winjs && !winrt)

		/*
			Run a PowerShell script converted to Int64
		*/
		var p = new sys.io.Process("powershell.exe", ["-NoProfile", "-File",
		CoolUtil.getConsoleScript("GetAccentColor.ps1")]);

		var accent = Std.int(Std.parseFloat(p.stdout.readLine()));
		trace('Accent: $accent', 'to hex: #${StringTools.hex(accent, 6)})');
		p.close();
		
		// Haxe reads this as an FLOAT, not INT
		return accent;
		#else // I don't know how accent colors works on other systems...
		FlxG.log.error("You're using a platform that doesn't support accent colors!");
		return null;
		#end
	}

	private static function get_ACCENT_COLOR():FlxColor {
		return _accent;
	}

	private static function set_ACCENT_COLOR(value:Null<FlxColor>):FlxColor {
		_accent = (value != null) ? value : FlxColor.BLACK;

		trace('returned $_accent :: ${_accent.toWebString()}');
		return _accent;
	}
}