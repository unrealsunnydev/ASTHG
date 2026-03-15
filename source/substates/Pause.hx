package substates;

class Pause extends SubStateManager {
	var curSelected:Int = 0;
	var grpOptions:FlxTypedGroup<AsthgBitmapText>;
	var options:Array<String> = [];
	var options2:Array<String> = [
		'Resume',
		'Restart',
		'Exit to Menu'
	];

	var backd:FlxBackdrop;

	override function create() {
		options = options2;
		var bg:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.scrollFactor.set();
		bg.alpha = 0.20;
		add(bg);

		var bottomFill:AsthgSprite = new AsthgSprite(0,FlxG.height-16).createGraphic(FlxG.width, 20, FlxColor.BLACK);
		add(bottomFill);

		backd = new FlxBackdrop(Paths.image("UI/backdropY"), Y);
		backd.flipX = true;
		backd.x = FlxG.width - 130;
		backd.velocity.set(0, 20);
		backd.color = 0xff0c0c0c;
		add(backd);

		var fillWidth = FlxG.width - (backd.x + backd.width);
		var backdFill:AsthgSprite = new AsthgSprite(backd.x + backd.width, 0).createGraphic(Std.int(fillWidth), FlxG.height, backd.color);
		add(backdFill);

		grpOptions = new FlxTypedGroup<AsthgBitmapText>();
		add(grpOptions);

		var titleTxt:FlxBitmapText = new FlxBitmapText(20, bottomFill.y - 6, Locale.getString("title", "pause"), Paths.getAngelCodeFont("Roco"));
		titleTxt.setBorderStyle(flixel.text.FlxText.FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2, 0);
		add(titleTxt);

		regenerateMenu();
		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		super.create();
	}

	var cantUnpause:Float = 0.1;
	override function update(e:Float) {
		cantUnpause -= e;
		super.update(e);
		
		if(controls.BACK) {
			close();
			return;
		}

		if (controls.UP || controls.DOWN) {
			changeSelection(controls.UP ? -1 : 1);
			CoolUtil.playSound(ConstantSound.MENU_SCROLL);
		}
		var selected:String = options[curSelected];
		if (controls.ACCEPT && (cantUnpause <= 0)) {
			CoolUtil.playSound(ConstantSound.MENU_ACCEPT);
			switch (selected.toLowerCase()) {
				case 'resume':
					close();
				case 'restart':
					StateManager.resetState();
				case 'exit to menu':
					#if DISCORD_ALLOWED DiscordClient.resetClientID(); #end
					StateManager.switchState(new states.MainMenu());
			}
		}

	}

	function regenerateMenu() {
		for (i in 0...grpOptions.members.length) {
			var obj:AsthgBitmapText = grpOptions.members[0];
			obj.kill();
			grpOptions.remove(obj, true);
			obj.destroy();
		}

		for (num => str in options) {
			var item:AsthgBitmapText = AsthgBitmapText.createAngelCode(backd.x + 67, 60, Locale.getString(str, "pause").toUpperCase());
			item.y += (30 * (num - (options.length / 2))) + item.height;
			item.x -= (item.width/2);
			item.ID = num;
			grpOptions.add(item);
		}
		curSelected = 0;
		changeSelection();
	}


	function changeSelection(change:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + change, 0, grpOptions.length - 1);
		for (num => item in grpOptions.members) {
			item.ID = num - curSelected;
			item.color = (item.ID != 0) ? FlxColor.WHITE : (ClientPrefs.data.accentColors ? SystemUtil.ACCENT_COLOR : FlxColor.RED);
		}
	}

}