package states;

import flixel.addons.plugin.FlxScrollingText;
import options.OptionsState;
import flixel.effects.FlxFlicker;
import backend.StateManager;
import flixel.input.mouse.FlxMouse;
import flixel.group.FlxGroup;

class MainMenu extends StateManager {
	public static var curSelected:Int = 0;
	var group:FlxTypedGroup<AsthgBitmapText>;
	var options:Array<String> = [
		"Save Select",
		"Options",
		#if MODS_ALLOWED "Mods", #end
		"Exit"
	];

	override function create() {
		Paths.clearStoredMemory();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Locale.getString('main_menu', 'discord'), null);
		#end

		var bg:flixel.FlxSprite = AsthgSprite.createGradient(FlxG.width, FlxG.height, [0xFF793BFF, 0xFF95EDFF], 4, 32, false);
		add(bg);

		var bgLayer:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgLayer.alpha = ClientPrefs.data.backLayers;
		add(bgLayer);

		var backd:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropX"), X);
		backd.y = 15;
		backd.flipY = true;
		
		backd.color = (ClientPrefs.data.accentColors ? SystemUtil.ACCENT_COLOR : FlxColor.YELLOW);
		backd.dirty = true;
		backd.velocity.set(-30, 0);
		add(backd);
		
		var backdFill:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, Math.floor(backd.y), backd.color);
		add(backdFill);
		
		var titleTxt:AsthgBitmapText = AsthgBitmapText.createAngelCode(0, 2, Locale.getString("title", "main_menu"), "HUD");
		
		var titleSpr = FlxScrollingText.add(titleTxt, new openfl.geom.Rectangle(0, titleTxt.y, FlxG.width, titleTxt.height), 2, 0, titleTxt.text);
		add(titleSpr);
		FlxScrollingText.startScrolling(titleSpr);

		var version:FlxBitmapText = new FlxBitmapText(0, 0, "v" + CoolUtil.getProjectInfo('version'), FlxBitmapFont.fromMonospace(Paths.getFolderPath("AbsoluteSystem.png", "fonts"), Constants.ABSOLUTE_FONT_GLYPHDATA, flixel.math.FlxPoint.get(8, 8)));
		if (!StringUtil.isNull(CoolUtil.getProjectInfo("buildNumber"))) {
			version.text += " " + CoolUtil.getProjectInfo("buildNumber");
		}
		version.setPosition(FlxG.width - version.width - 7, FlxG.height - version.height - 2);
		add(version);

		group = new FlxTypedGroup<AsthgBitmapText>();
		add(group);

		for (num => str in options) {
			var menu:AsthgBitmapText = AsthgBitmapText.createAngelCode(10, 30, Locale.getString(str, "main_menu"), "HUD");
			menu.x += (32 * num);
			menu.y += (18 * num);
			menu.ID = num;
			group.add(menu);
		}

		super.create();
		changeItem();
		CoolUtil.playMusic("MainMenu");
	}

	
	var selectedSomethin:Bool = false;
	override function update(elapsed:Float) {
		if (!selectedSomethin) {
			if (controls.justPressed('up') || controls.justPressed('down')) {
				changeItem(controls.justPressed('up') ? -1 : 1);
				CoolUtil.playSound(ConstantSound.MENU_SCROLL);
				controls.vibrate(1.5, 1.2, 10);
			}

			if (controls.justPressed('accept')) {
				
				if (options[curSelected].toLowerCase() != "exit")
					CoolUtil.playSound(ConstantSound.MENU_ACCEPT);

				selectedSomethin = true;
				group.forEach(function(txt:FlxBitmapText) {
					if (curSelected == txt.ID) {
						FlxFlicker.flicker(txt, 1, (!ClientPrefs.data.flashing) ? 0.3 : 0.06, false, false, function(flick:FlxFlicker) {
							var daChoice:String = options[curSelected];

							switch (daChoice.toLowerCase()) {
								case 'save select':
									LoadingState.switchStates(new SaveSelect(), true);
								case 'options':
									LoadingState.switchStates(new OptionsState());
									OptionsState.onPlayState = false;
								case 'mods':
									LoadingState.switchStates(new ModsMenu());
								case 'exit':
									#if sys
									Sys.exit(0);
									CoolUtil.playSound(ConstantSound.MENU_ACCEPT);
									#else
									CoolUtil.playSound("Fail");
									return;
									#end
							}
						});
					}
				});
			}

			if (controls.justPressed("back")) {
				CoolUtil.playSound(ConstantSound.MENU_BACK);
				StateManager.switchState(new TitleState());
			}
		}

		if (FlxG.keys.justPressed.SEVEN) {
			StateManager.switchState(new states.editor.MainMenuEdt());
		}

		super.update(elapsed);
	}

	function changeItem(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, group.length - 1);
		
		group.forEach(function(txt:FlxBitmapText) {
			txt.color = (txt.ID == curSelected) ? 0xFFFF0000 : 0xFFFFFFFF;
		});
	}
}