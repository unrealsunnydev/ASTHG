/**
	Sunnydev31 - 2025-12-22
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
**/

package options.substates;

import firetongue.FireTongue;
import openfl.utils.Assets;

class Language extends SubStateManager {
	#if (TRANSLATIONS_ALLOWED && target.unicode)
	/*
		^^ we need to be shure that Unicode are supported, or
		translations will be weird as hell ^^
	*/
	var grpLanguages:FlxTypedGroup<AsthgText> = new FlxTypedGroup<AsthgText>();
	var languages:Array<String> = [];
	var curSelected:Int = 0;
	public function new() {
		super();

		var bg = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, 0x50000000);
		bg.screenCenter();
		add(bg);
		add(grpLanguages);

		languages = Main.tongue.locales;
		for (num => str in languages) {
			// LanguageRegionNative breaks and I don't know why
			var LangRegionNative = Main.tongue.getIndexString(LanguageNative, languages[num]) + " (" + Main.tongue.getIndexString(RegionNative, languages[num]) + ")";
			var text:AsthgText = AsthgText.create(0, 300, LangRegionNative);
			text.format(16, "center", FlxColor.WHITE);
			text.ID = num;
			if (languages?.length < 7) {
				text.screenCenter(Y);
				text.y += (20 * (num - (languages?.length / 2))) + text?.size;
			}
			text.screenCenter(X);
			grpLanguages.add(text);
		}

		curSelected = languages.indexOf(ClientPrefs.data.language);
		if(curSelected < 0) {
			ClientPrefs.data.language = ClientPrefs.defaultData.language;
			curSelected = Std.int(Math.max(0, languages.indexOf(ClientPrefs.data.language)));
		}
		changeSelected();
	}

	var changedLanguage:Bool = false;
	override function update(elapsed:Float) {
		super.update(elapsed);

		var mult:Int = (FlxG.keys.pressed.SHIFT) ? 4 : 1;
		if(controls.justPressed('up')) changeSelected(-1 * mult);
		if(controls.justPressed('down')) changeSelected(1 * mult);
		if(FlxG.mouse.wheel != 0) changeSelected(FlxG.mouse.wheel * mult);

		if(controls.justPressed('back')) {
			if(changedLanguage) {
				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				StateManager.resetState();
			}
			else close();
			CoolUtil.playSound('MenuCancel');
		}

		if(controls.justPressed('accept')) {
			CoolUtil.playSound('MenuAccept');
			ClientPrefs.data.language = languages[curSelected];
			ClientPrefs.saveSettings();
			Main.tongue.initialize({locale: ClientPrefs.data.language});
			changedLanguage = true;
		}
	}

	function changeSelected(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, languages.length-1);
		for (num => lang in grpLanguages) {
			lang.alpha = (num == curSelected) ? 1 : 0.6;
		}
		CoolUtil.playSound('MenuChange');
	}
	#end
}