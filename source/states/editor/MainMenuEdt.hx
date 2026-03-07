package states.editor;

class MainMenuEdt extends StateManager {
	var selected:Int = 0;
	var group:FlxTypedGroup<AsthgText>;
	var options:Array<String> = [];
	
	override public function create() {
		var bg:flixel.FlxSprite = AsthgSprite.createGradient(FlxG.width, FlxG.height, [0xFF353535, 0xFF979797], 4, 32, false);
		add(bg);

		
		group = new FlxTypedGroup<AsthgText>();
		add(group);

		for (num => str in options) {
			var menu:AsthgText = AsthgText.create(10, 30, Locale.getString("title_" + str, "editor_menu"));
			menu.format(16, "center", FlxColor.WHITE);
			menu.y += (18 * num);
			menu.ID = num;
			group.add(menu);
		}

		super.create();
		changeItem();
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
				CoolUtil.playSound("MenuAccept");
				selectedSomethin = true;
				//switch(options[selected].toLowerCase()) {}
			}
	  		if (controls.justPressed("back")) {
				CoolUtil.playSound("MenuCancel");
				StateManager.switchState(new states.MainMenu());
			}
		}
		super.update(elapsed);
	}

	function changeItem(change:Int = 0) {
		selected = FlxMath.wrap(selected + change, 0, group.length - 1);
		
		group.forEach(function(txt:AsthgText) {
			txt.color = (txt.ID == selected) ? 0xFF002896 : 0xFFFFFFFF;
		});
	}
}