package states;

import flixel.input.keyboard.FlxKey;

class Init extends StateManager {
	public static var muteKeys:Array<FlxKey> = [FlxKey.ZERO];
	public static var volumeDownKeys:Array<FlxKey> = [FlxKey.NUMPADMINUS];
	public static var volumeUpKeys:Array<FlxKey> = [FlxKey.NUMPADPLUS];

	override public function create() {
		trace('Init created');

		FlxG.fixedTimestep = false;
		FlxG.game.focusLostFramerate = 60;
		ClientPrefs.loadPrefs();
		
		Main.tongue.initialize({
			locale: ClientPrefs.data.language,
			replaceMissing: false
		});

		#if MODS_ALLOWED
		polymod.Polymod.scan(Constants.POLYMOD_SETTINGS.modRoot);
		#end

		SystemUtil.ACCENT_COLOR = SystemUtil.loadAccentColor();

		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;

		
		if (FlxG.gamepads.numActiveGamepads > 0) {
			Controls.instance.controllerMode = true;
		}

		#if debug 
		// DEBUGING PURPOSES ONLY
		StateManager.switchState(new states.MainMenu());
		#else
		StateManager.switchState(new states.TitleState());
		#end
	}
}