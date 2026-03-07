/**
	Sunnydev31 - 2025-12-22
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
**/

package options;

import flixel.addons.display.FlxSliceSprite;
import flixel.math.FlxRect;

class OptionsState extends StateManager {
	var options:Array<String> = [
		"System",
		"Display",
		"Gameplay",
		"Controls"
		#if TRANSLATIONS_ALLOWED , "Language" #end
	];
	private var curSelected:Int = 0;
	private var grpTabs:FlxTypedGroup<FlxBitmapText>;
	
	var optBG:FlxSliceSprite = null;

	public static var onPlayState:Bool = false;

	override function create() {
		var bg:flixel.FlxSprite = AsthgSprite.createGradient(FlxG.width, FlxG.height, [0x4FFFFFFF, 0x28FFFFFF], 2, 37, false);
		add(bg);

		// tabs group
		grpTabs = new FlxTypedGroup<FlxBitmapText>();

		for (num => str in options) {
			var txt:FlxBitmapText = new FlxBitmapText(0, 0, Locale.getString("title_" + str, "options"), Paths.getAngelCodeFont("Roco"));
			txt.screenCenter();
			txt.y += (20 * (num - (options.length / 2)));
			txt.screenCenter(X);
			grpTabs.add(txt);
		}
		
		optBG = AsthgSprite.createSliced(0, 0, 7, 7, "UI/button", [3, 3, 1, 1], [0, 0, 7, 7]);
		add(optBG);

		add(grpTabs);

		updateTabVisuals();

		super.create();
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.justPressed('up') || controls.justPressed('down')) {
			changeSelection(controls.justPressed('up') ? -1 : 1);
			CoolUtil.playSound(ConstantSound.MENU_SCROLL);
		}

		if (controls.justPressed('accept')) {
			openSelectedSubstate(options[curSelected]);
		}

		if (controls.justPressed('back')) {
			ClientPrefs.saveSettings();
			CoolUtil.playSound(ConstantSound.MENU_BACK);
			StateManager.switchState(new states.MainMenu());
		}
	}

	private function updateTabVisuals():Void {
		for (idx => t in grpTabs.members) {
			t.color = (idx == curSelected) ? (ClientPrefs.data.accentColors ? SystemUtil.ACCENT_COLOR : FlxColor.WHITE) : FlxColor.WHITE;
			optBG.x = grpTabs.members[curSelected].x - 5;
			optBG.y = grpTabs.members[curSelected].y - 4;
			optBG.width = grpTabs.members[curSelected].width + 8;
			optBG.height = grpTabs.members[curSelected].height + 6;
		}
	}

	function changeSelection(change:Int) {
		curSelected = FlxMath.wrap(curSelected + change, 0, options.length - 1);
		updateTabVisuals();
	}

	function openSelectedSubstate(lbl:String) {
		if (lbl.toLowerCase() == 'fail') {
			CoolUtil.playSound("Fail");
		} else { CoolUtil.playSound(ConstantSound.MENU_ACCEPT); }
		switch (lbl.toLowerCase()) {
			case "system": openSubState(new options.substates.System());
			case "display": openSubState(new options.substates.Display());
			case "gameplay": openSubState(new options.substates.Gameplay());
			case "controls": openSubState(new options.substates.Controls());
			case "language": openSubState(new options.substates.Language());
			default: trace('Unknown option: "$lbl"'); return; 
		}
	}

	override function destroy() {
		super.destroy();
	}
}