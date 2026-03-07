/**
	Sunnydev31 - 2025-12-22
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
**/

package states;

import objects.Character;
import flixel.tween.*;

class SaveSelect extends StateManager {
	public var camFront:FlxCamera;

	public var saveGroup:FlxTypedGroup<SaveEntry>;
	var curSelected:Int = 0;

	var selectSave:AsthgSprite;
	var arrow1:AsthgSprite;
	var arrow3:AsthgSprite;
	var arrow2:AsthgSprite;
	var arrow4:AsthgSprite;

	override function create() {
		Paths.clearUnusedMemory();
		Paths.clearStoredMemory();

		saveGroup = new FlxTypedGroup<SaveEntry>();

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Locale.getString('save_select', 'discord'));
		#end

		camFront = new FlxCamera();
		camFront.visible = true;
		camFront.bgColor.alpha = 5;
		FlxG.cameras.add(camFront, false);
		
		var bg:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, 0xff4d4dff);
		add(bg);
		
		var bgLayer:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bgLayer.alpha = ClientPrefs.data.backLayers;
		add(bgLayer);
		
		var title:FlxBitmapText = new FlxBitmapText(FlxG.width/2, FlxG.height - 26, Locale.getString("title", "save_select"), Paths.getAngelCodeFont("GameOver"));
		title.x -= title.width / 2;
		add(title);

		for (i in 0...Constants.SAVE_ENTRY_LIMIT) {
			var saveEntry:SaveEntry = new SaveEntry(i);
			saveEntry.setPosition(90 * i, 50);
			saveEntry.cameras = [camFront];
			saveGroup.add(saveEntry);
		}
		add(saveGroup);

		//Do not touch the position of this sprite
		selectSave = AsthgSprite.create(saveGroup.members[curSelected].x, saveGroup.members[curSelected].y, "saveSelect/selected");
		FlxTween.color(selectSave, 0.2, Constants.SAVE_SELECTED_FRAME_COLOR[0], Constants.SAVE_SELECTED_FRAME_COLOR[1], {type: FlxTweenType.PINGPONG, ease: FlxEase.linear});
		selectSave.cameras = [camFront];
		add(selectSave);

		// Positions of all the sprites above are updated on `changeSelection()`
		arrow1 = AsthgSprite.create(0, 0, "saveSelect/selectArrow");
		arrow1.color = Constants.SAVE_SELECTED_ARROW_COLOR[0];
		arrow1.cameras = [camFront];
		add(arrow1);

		arrow3 = AsthgSprite.create(0, 0, "saveSelect/selectArrow");
		arrow3.color = Constants.SAVE_SELECTED_ARROW_COLOR[1];
		arrow3.cameras = [camFront];
		add(arrow3);

		arrow2 = AsthgSprite.create(0, 0, "saveSelect/selectArrowFlip");
		arrow2.color = arrow1.color;
		arrow2.cameras = [camFront];
		add(arrow2);

		arrow4 = AsthgSprite.create(0, 0, "saveSelect/selectArrowFlip");
		arrow4.color = arrow3.color;
		arrow4.cameras = [camFront];
		add(arrow4);

		camFront.follow(selectSave, LOCKON, 40);
		changeSelection();

		super.create();
		CoolUtil.playMusic("SaveSelect");
	}

	override function update(e:Float) {
		super.update(e);

		if (controls.justPressed('accept')) {
			LoadingState.switchStates(new states.PlayState(), true);
		}

		if (controls.justPressed('back')) {
			StateManager.switchState(new states.MainMenu());
		}

		if (controls.justPressed('left')) {
			changeSelection(-1);
		} else if (controls.justPressed('right')) {
			changeSelection(1);
		}
	}

	function changeSelection(count:Int = 0) {
		curSelected = FlxMath.wrap(curSelected + count, 0, saveGroup.length - 1);

		var member = cast saveGroup.members[curSelected];
		if (member == null) {
			trace("[WARNING] member is null!");
			return;
		}

		selectSave.setPosition	(member.x,	member.y);
		arrow1.setPosition		(member.x,	member.y + 14);
		arrow2.setPosition		(arrow1.x,	arrow1.y + 18);
		arrow3.setPosition		(arrow2.x,	member.y + 65);
		arrow4.setPosition		(arrow3.x,	arrow3.y + 30);

		CoolUtil.playSound("MenuChange");
	}
}


@:nullSafety(Loose)
class SaveEntry extends FlxSpriteGroup {
	public var character:Null<Character>;
	public var emeralds:Array<AsthgSprite> = new Array<AsthgSprite>();
	public function new(id:Int) {
		super();

		var save:AsthgSprite = AsthgSprite.create(0, 0, "saveSelect/save");
		add(save);

		var colors:Array<Array<FlxColor>> = [
			[0xff0080e0, 0xff00b4cc, 0xff00c0e0, 0xff80e0e0],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xff2bff00, 0xffda0000, 0xffae0000, 0xff790000],
			[0xfffbff00, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffd4d4d4, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff0000, 0xffda0000, 0xffae0000, 0xff790000],
			[0xffff00d4, 0xffda0000, 0xffae0000, 0xff790000],
		];

		for (i in 0...7) {
			var emerald:AsthgSprite = AsthgSprite.create(2, save.height - 12, "saveSelect/emerald");
			emerald.x += (emerald.width * i) + i;
			add(emerald);
			emerald.applyPalette(colors[i]);
			emeralds.push(emerald);
		}
	}
}