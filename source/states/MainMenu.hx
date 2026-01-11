package states;

import flixel.addons.plugin.FlxScrollingText;
import options.OptionsState;
import flixel.effects.FlxFlicker;
import backend.StateManager;
import flixel.input.mouse.FlxMouse;
import flixel.group.FlxGroup;

class MainMenu extends StateManager {
	public static var curSelected:Int = 0;
	var group:FlxTypedGroup<FlxBitmapText>;
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
		backd.color = SystemUtil.ACCENT_COLOR;
		backd.velocity.set(-30, 0);
		add(backd);
		
		var backdFill:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, Math.floor(backd.y), backd.color);
		add(backdFill);

		var titleTxt:FlxBitmapText = new FlxBitmapText(0, 2, Locale.getString("title", "main_menu"), Paths.getAngelCodeFont("HUD"));
		
		var titleSpr = FlxScrollingText.add(titleTxt, new openfl.geom.Rectangle(0, titleTxt.y, FlxG.width, titleTxt.height), 2, 0, titleTxt.text);
		add(titleSpr);
		FlxScrollingText.startScrolling(titleSpr);

		var version:FlxBitmapText = new FlxBitmapText(0, 0, "v" + CoolUtil.getProjectInfo('version'), FlxBitmapFont.fromMonospace(Paths.getFolderPath("AbsoluteSystem.png", "fonts"), Constants.ABSOLUTE_FONT_GLYPHDATA, flixel.math.FlxPoint.get(8, 8)));
		if (!StringUtil.isNull(CoolUtil.getProjectInfo("buildNumber"))) {
			version.text += " " + CoolUtil.getProjectInfo("buildNumber");
		}
		version.setPosition(FlxG.width - version.width - 7, FlxG.height - version.height - 2);
		add(version);

		group = new FlxTypedGroup<FlxBitmapText>();
		add(group);

		for (num => str in options) {
			var menu:FlxBitmapText = new FlxBitmapText(10, 30, Locale.getString(str, "main_menu"), Paths.getAngelCodeFont("HUD"));
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
			if (controls.justPressed('up')) {
				changeItem(-1);
				CoolUtil.playSound("MenuChange");
				controls.vibrate(0.5, 0.2, 10);
			}
			if (controls.justPressed('down')) {
				changeItem(1);
				CoolUtil.playSound("MenuChange");
				controls.vibrate(0.5, 0.2, 10);
			}
			if (controls.justPressed('accept')) {
				if (options[curSelected].toLowerCase() != "exit")
					CoolUtil.playSound("MenuAccept");
				selectedSomethin = true;
				group.forEach(function(txt:FlxBitmapText) {
					if (curSelected != txt.ID) {
						FlxTween.tween(txt, {alpha: 0}, 0.6, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween) { txt.kill(); }
						});
					}
					else {
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
									#if sys Sys.exit(0); CoolUtil.playSound("MenuAccept");
									#else CoolUtil.playSound("Fail");
									return; #end
							}
						});
					}
				});
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