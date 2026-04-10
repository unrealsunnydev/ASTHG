package backend;

import flixel.sound.FlxSoundGroup;

class CoolUtil {
	/**
		[source-code](https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/CoolUtil.hx#L161)

		Helper Function to Fix Save Files for Flixel 5

		-- EDIT: [November 29, 2023] --

		this function is used to get the save path, period.
		since newer flixel versions are being enforced anyways.
		@crowplexus
	**/
	@:access(flixel.util.FlxSave.validate)
	inline public static function getSavePath():String {
		final company:String = getProjectInfo('company');
		return '$company/${flixel.util.FlxSave.validate(getProjectInfo('file'))}';
	}

	public static function getProjectInfo(metaIndex:String) {
		return FlxG.stage.application.meta.get(metaIndex);
	}

	/**
		Noticed that loopTime uses MILLISECONDS and not SAMPLES? this converts it into `ms`
		@param sample Sample of your track
		@param hz Hz of the file track, needs to be an entire Hz of the file, defaults to 44100
		@return Float
	**/
	inline public static function getSampleLoop(sample:Int, ?hz:Int = 44100):Float {
		return (sample * 1000) / hz;
	}
	
	/**
		Plays a sound
		@param sound Sound file
		@param loop Loops or not the sound
		@param volume Volume for this sound
		@return FlxSound
	**/
	inline public static function playSound(sound:String, ?loop:Bool = false, ?volume:Float = 1.0) {
		FlxG.sound.play(Paths.sound(sound), volume, loop);
	}

	/**
		Parses an String and convert it into a Bool
		@param k 
		@return Null<Bool> (Bool->false if invalid value)
	**/
	public static function parseBool(k:String):Bool {
		return switch (k) {
			case 'true': true;
			case 'false': false;
			default: false;
		}
	}

	public static var musJson:Dynamic;

	/**
		Custom music player!
		@param sound Music name or path
		@param volume Volume to play `this` music
		@param group Sets a sound group for `this` music
	**/
	public static function playMusic(sound:String, ?volume:Float = 1.0, ?group:FlxSoundGroup) {
		var asset = Paths.music(sound);

		var musJson:Dynamic = null;
		if (Paths.fileExists('music/$sound.json', TEXT))
			musJson = Paths.parseJson('music/$sound.json');
		else {
			trace('[playMusic] No metadata found for music "$sound".');
			musJson = {
				name: sound,
				artist: "Unknown (No Metadata)",
				album: "Unknown (No Metadata)",

				loop: false,
				loopStart: 0
			};
		}

		var looped:Bool = (Reflect.field(musJson, "loop") == true);
		var loopTimeVal:Float = 0;
		if (looped && Reflect.hasField(musJson, "loopStart")) {
			var hz:Int = (Reflect.field(musJson, "heartz") ?? 44100);
			loopTimeVal = CoolUtil.getSampleLoop(musJson.loopStart, hz);
		}

		FlxG.sound.music ??= new FlxSound();
		if (FlxG.sound.music.active) FlxG.sound.music.stop();

		FlxG.sound.music.loadEmbedded(asset, looped);

		// Applys metadata before playing to not break the loop
		FlxG.sound.music.looped = looped;
		FlxG.sound.music.loopTime = loopTimeVal;
		FlxG.sound.music.volume = volume;
		FlxG.sound.music.persist = true;
		FlxG.sound.music.group = group ?? FlxG.sound.defaultMusicGroup;

		FlxG.sound.music.play();
	}

	inline public static function getConsoleScript(file:String, folder:String = "pwsh_scripts"):String {
		#if sys
		return (Sys.getCwd() + Paths.file('$folder/$file', TEXT, "other"));
		#else
		trace("Unsupported platform to run shell commands");
		#end
	}
}

