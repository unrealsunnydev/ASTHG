package;

import flixel.FlxGame;
import firetongue.FireTongue;
import openfl.display.Sprite;

import openfl.events.UncaughtErrorEvent;

class Main extends Sprite {
	public static var tongue:FireTongue;
	
	public function new() {
		super();

		Controls.instance = new Controls();
		ClientPrefs.loadDefaultKeys();
				
		FlxG.save.bind('game', CoolUtil.getSavePath());
		
		#if MODS_ALLOWED
		Mods.loadMods(Mods.getAllIds());
		#end

		openfl.utils._internal.Log.level = openfl.utils._internal.Log.LogLevel.INFO;

		tongue = new FireTongue(#if sys VanillaSys #else OPENFL #end, Case.Unchanged);
		
		var game:FlxGame = new FlxGame(0, 0, states.Init, #if (flixel < "5.0.0") 1, #end 60, 60, true);
		
		#if web
		// Tells the HTML to use pixelated images
		Application.current.window.element.style.setProperty("image-rendering", "pixelated");
		#end

		addChild(game);
		
		openfl.Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onCrash);
	}
	
	public static function onCrash(e:UncaughtErrorEvent) {
		final folderPath:String = "./crash/";
		var date:String = DateTools.format(Date.now(),
			Locale.getString("format_date", null, ["-", "-"]) + "_" + Locale.getString("format_hour", null, ["-", "-"]));
			
		var msg:String = "Error!\n";
		
		msg += e.error + "\n\nReport this in Github: https://github.com/sunkydunky31/ASTHG/issues";

		#if sys
		if (!sys.FileSystem.exists(folderPath))
			sys.FileSystem.createDirectory(folderPath);
			
		sys.io.File.saveContent(folderPath + 'ASTHG_${date}.log', msg);
		
		Sys.println(msg);
		#end
		
		lime.app.Application.current.window.alert(msg, "Something is wrong...");
		
		#if DISCORD_ALLOWED
		DiscordClient.shutdown();
		#end
		
		#if sys
		Sys.exit(1);
		#end
	}
}
