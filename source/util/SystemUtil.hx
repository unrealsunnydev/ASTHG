package util;

class SystemUtil {
	inline public static function openFolder(folder:String, absolute:Bool = false) {
		#if sys
		if(!absolute) folder =  Sys.getCwd() + folder;

		folder = folder.replace('/', '\\');
		if(folder.endsWith('/')) folder.substr(0, folder.length - 1); 

		var command:String = "";
		#if linux
		command = '/usr/bin/xdg-open';
		#elseif windows
		command = 'explorer.exe';
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

	@:privateAccess()
	private static var _accent:FlxColor = FlxColor.WHITE;
	public static var ACCENT_COLOR(get, set):FlxColor;
	inline public static function loadAccentColor():Null<FlxColor> {
		trace("Loading accent colors...");

		#if (windows && !winjs && !winrt) // Is Windows and not Web-targets

		/*
			Run a PowerShell script converted to Int64
		*/
		var p = new sys.io.Process("powershell.exe", ["-NoProfile", "-File",
		CoolUtil.getConsoleScript("GetAccentColor.ps1")]);

		var accent = Std.int(Std.parseFloat(p.stdout.readLine()));
		p.close();
		
		trace("Loaded!");
		// Haxe reads this as an FLOAT, not INT
		return accent;
		#else // I don't know how accent colors works on other systems...
		FlxG.log.error("You're using a platform that doesn't support accent colors!");
		return FlxColor.WHITE;
		#end
	}

	private static function get_ACCENT_COLOR():FlxColor {
		return _accent;
	}

	private static function set_ACCENT_COLOR(value:Null<FlxColor>):FlxColor {
		_accent = value ?? FlxColor.BLACK;

		return _accent;
	}
}