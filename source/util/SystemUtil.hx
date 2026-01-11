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

	public static var ACCENT_COLOR(default, set):FlxColor = FlxColor.WHITE;
	inline public static function loadAccentColor():Null<Dynamic> {
		#if (web || flash || winjs) // WinJS actually is HTML-based app
		FlxG.log.error("You're using a platform that doesn't support accent colors!");
		return;
		#elseif windows

		/*
			Run a PowerShell script converted to Int64
		*/
		var p = new sys.io.Process("powershell.exe", ["-NoProfile",
		"-File", Sys.getCwd() + Paths.file("pwsh_scripts/GetAccentColor.ps1", TEXT, "other")]);

		var accent = Std.parseFloat(p.stdout.readLine());
		trace("Accent: " + accent, "to float: " + accent, "to int: " + Std.int(accent), "to hex: " + ("#" + StringTools.hex(Std.int(accent), 6)));
		p.close();
		
		// Haxe reads this as an FLOAT, not INT
		return FlxColor.fromString("#" + StringTools.hex(Std.int(accent), 6));
		#end
	}

	private static function set_ACCENT_COLOR(value:Dynamic):FlxColor {
		if (value != null) {
			trace('returned $value :: #${StringTools.hex(value, 6)}');
			return value;
		}

		return FlxColor.BLACK;
	}
}