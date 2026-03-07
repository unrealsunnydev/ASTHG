package states;

import flixel.effects.FlxFlicker;

class TitleState extends StateManager {
	var pressStart:FlxBitmapText;

	override function create() {
		Paths.clearUnusedMemory();

		var bg:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		pressStart = new FlxBitmapText(0, FlxG.height - 20, Locale.getString("press_start", "title_screen",
		[backend.InputFormatter.getControlNames('accept')]), Paths.getAngelCodeFont("HUD"));
		pressStart.screenCenter(X);
		add(pressStart);

		if (!ClientPrefs.data.flashing)
			FlxFlicker.flicker(pressStart, 17, 0.12, true);

		CoolUtil.playMusic('TitleScreen');

		super.create();
	}

	override function update(e:Float) {
		if (controls.justPressed('accept'))
			StateManager.switchState(new states.MainMenu());

	}
}