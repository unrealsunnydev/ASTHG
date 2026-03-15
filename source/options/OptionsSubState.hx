/**
	Sunnydev31 - 2025-12-22
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
**/

package options;

import options.Option;
import backend.InputFormatter;

class OptionsSubState extends SubStateManager {
	var selected:Int = 0;
	var options:Array<Option>;
	
	var grpOptions:FlxTypedGroup<AsthgText>;
	var grpValues:FlxTypedGroup<AsthgText>;

	var txtDesc:AsthgText;
	var sprDesc:AsthgSprite;

	public function new() {
		super();
		var bg:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		add(bg);
		
		grpOptions = new FlxTypedGroup<AsthgText>();
		add(grpOptions);

		grpValues = new FlxTypedGroup<AsthgText>();
		add(grpValues);

		for (i in 0...options.length) {
			var optName:AsthgText = AsthgText.create(40, 10, options[i].flag);
			optName.y += 26 * (i - (options.length / 2));
			grpOptions.add(optName);


			var optValues:AsthgText = AsthgText.create(210, optName.y, Std.string(options[i].value));
			optValues.alignment = "right";
			grpValues.add(optValues);
		}

		sprDesc = new AsthgSprite(0, FlxG.height * 0.7).createGraphic(FlxG.stage.stageWidth, 30, FlxColor.BLACK);
	}

	override public function update(e:Float) {
		if(controls.BACK) {
			close(); CoolUtil.playSound(ConstantSound.MENU_BACK);
		}
	}

	public function addOption(option:Option) {
		if(options == null || options.length < 1) options = [];
		options.push(option);
		return option;
	}
	
	function changeSelection(change:Int = 0) {
		selected = FlxMath.wrap(selected + change, 0, options.length - 1);
	}
}