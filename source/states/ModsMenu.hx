package states;

import openfl.display.BitmapData;
import flixel.FlxSprite;

class ModsMenu extends StateManager {
	#if MODS_ALLOWED

	override function create() {
		Paths.clearStoredMemory();

		var bg:FlxSprite = AsthgSprite.createGradient(FlxG.width, FlxG.height, [0xFFCA3030, 0xFF510077], 4, 32, false);
		add(bg);
		
		var titleTxt:FlxBitmapText = new FlxBitmapText(0, 2, Locale.getString("title", "mods_menu"), Paths.getAngelCodeFont("HUD"));
		add(titleTxt);

		super.create();
	}

	override function update(e:Float) {
		if (controls.justPressed("back")) {
			CoolUtil.playSound("MenuCancel");
			StateManager.switchState(new states.MainMenu());
		}

		if (controls.justPressed("up")) {
			CoolUtil.playSound("MenuChange");
		}

		super.update(e);
	}
	#end
}
