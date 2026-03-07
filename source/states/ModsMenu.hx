package states;

#if MODS_ALLOWED
import polymod.Polymod;
#end
import openfl.display.BitmapData;


class ModsMenu extends StateManager {
	var curSelected:Int = 0;
	var grpMods:FlxTypedGroup<ModEntry>;

	#if MODS_ALLOWED
	override function create() {
		Paths.clearStoredMemory();

		var bg:flixel.FlxSprite = AsthgSprite.createGradient(FlxG.width, FlxG.height, [0xFFCA3030, 0xFF510077], 4, 32, false);
		add(bg);
		
		var titleTxt:AsthgBitmapText = AsthgBitmapText.createAngelCode(FlxG.width/2, 2, Locale.getString("title", "mods_menu"), "Roco");
		titleTxt.x -= (titleTxt.width/2);
		add(titleTxt);

		grpMods = new FlxTypedGroup<ModEntry>();
		add(grpMods);

		for (i in Mods.getAll(false)) {
			var mod:ModEntry = new ModEntry(17, 40, i);
			mod.y += 40;
			grpMods.add(mod);
		}

		changeSelection(0);

		super.create();
	}

	override function update(e:Float) {
		if (controls.justPressed("back")) {
			CoolUtil.playSound(ConstantSound.MENU_BACK);
			StateManager.switchState(new states.MainMenu());
		}

		if (controls.justPressed("up") || controls.justPressed("down")) {
			CoolUtil.playSound(ConstantSound.MENU_SCROLL);
			changeSelection(controls.justPressed("up") ? -1 : 1);
		}

		super.update(e);
	}

	function changeSelection(idx:Int):Void {
		if (grpMods.length <= 0) return;

		curSelected = FlxMath.wrap(curSelected + idx, 0, grpMods.length - 1);
		for (i in 0...grpMods.length) {
			var mod:ModEntry = grpMods.members[i];
			mod.selected = (i == curSelected);
		}
	}
	#end
}

private class ModEntry extends FlxSpriteGroup {
	#if MODS_ALLOWED
	public var meta:ModMetadata;
	public var enabled:Bool;
	public var selected:Bool = false;

	public var icon:AsthgSprite = new AsthgSprite(0, 0).createGraphic(18, 18, FlxColor.BLACK);
	public var text:AsthgBitmapText = AsthgBitmapText.createAngelCode(0, 0, "", "Mania0");

	// Mod Meta Info
	public var name:String = "Unknown Mod";
	public var desc:String = "No description.";
	public var version:String = "0";
	public var author:String = "Unknown author";
	public var compatible:Null<Bool> = true;
	
	var bg:flixel.addons.display.FlxSliceSprite;
	var lastSelected:Bool = false;
	var unselectedRect:flixel.math.FlxRect = flixel.math.FlxRect.get(0, 0, 7, 7);
	var selectedRect:flixel.math.FlxRect = flixel.math.FlxRect.get(7, 0, 7, 7);

	public function new(x:Float = 0, y:Float = 0, ?meta:Null<ModMetadata> = null) {
		super();

		if (meta != null) {
			this.meta = meta;
			this.name = meta.title;
			this.desc = meta.description;
			this.version = meta.modVersion;
			this.compatible = (meta.apiVersion == CoolUtil.getProjectInfo("version"));

			
			icon.loadGraphic(meta.iconPath ?? Paths.image("mods_menu"));
		}
		
		bg = AsthgSprite.createSliced(x, y, 404, 18, "UI/button", [3, 3, 1, 1], [0, 0, 7, 7]);
		add(bg);

		icon.setPosition(x + 5, y - 1);
		if (icon.width > 18)  icon.scale.x = 18 / icon.width;
		if (icon.height > 18) icon.scale.y = 18 / icon.height;
		add(icon);

		var border:AsthgSprite = AsthgSprite.create(icon.x - 1, icon.y - 1, "mods_menu/icon_border");
		add(border);

		text.x = x + 34;
		text.y = y + 3;
		text.text = name;
		add(text);
	}
	
	override public function update(e:Float) {
		super.update(e);

		if (selected != lastSelected) {
			lastSelected = selected;
			bg.sourceRect = (selected) ? selectedRect : unselectedRect;
		}
	}
	#end
}