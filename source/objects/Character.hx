/**
	Sunnydev31 - 2025-12-22
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
**/

package objects;

import flixel.math.FlxRect;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.frames.FlxFramesCollection;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import haxe.xml.Access;

class Character extends AsthgSprite {
	var controls = Controls.instance; // Lol

	public static final defaultPlayer:String = "sonic";
	public final lifeIcon:String = "liveIcon";
	public var json:CharacterData;
	private static var exAnim:Dynamic = {}; // Data store for new animations

	// Special events
	public var curPalette:Int = 0;

	public function new(x:Float, y:Float, ?char:String) {
		super(x, y);
		changeChar(char);

		maxVelocity.set(90, 200);
		acceleration.y = 0;
		velocity.x = 0;

		setFacingFlip(LEFT, true, false);
		setFacingFlip(RIGHT, false, false);

		origin.set(width / 2, height);
		updateHitbox();
	}

	public var isSuper:Bool = false;

	override function update(e:Float) {
		super.update(e);
	}

	public function changeChar(char:String) {
		if (Paths.fileExists('data/characters/$char.json', TEXT)) {
			json = cast Paths.parseJson('data/characters/$char.json');
		}
		else {
			json = cast Paths.parseJson('data/characters/$defaultPlayer');
			trace('Character not found, using default ($defaultPlayer)'.warn());
		}

		if (Reflect.hasField(json, "extraAnimations") && json.extraAnimations != null)
			for (extra in json.extraAnimations)
				addAnim(extra.name);

		loadAnimations();
		this.applyPalette([
			FlxColor.fromString(json.palettes[curPalette][0]),
			FlxColor.fromString(json.palettes[curPalette][1]),
			FlxColor.fromString(json.palettes[curPalette][2]),
			FlxColor.fromString(json.palettes[curPalette][3])
		]);
		playAnim("ANI_STOPPED");
	}

	function loadAnimations() {
		frames = Paths.getSparrowAtlas('characters/${json.name}/animData');

		var anims = json.animations;
		if (anims != null && anims?.length > 0) {
			for (anim in anims)
				if (anim?.indices?.length > 0) animation.addByIndices(anim.name, (StringUtil.isNull(anim.prefix)) ? anim.prefix  : anim.name, anim.indices, "", anim.fps ?? 30,
					anim.loop ?? false);
				else
					animation.addByPrefix(anim.name, (StringUtil.isNull(anim.prefix)) ? anim.prefix : anim.name, anim.fps ?? 30, anim.loop ?? false);
		}
	}

	public function playAnim(name:AnimList, force:Bool = false, reversed:Bool = false, frame:Int = 0) {
		animation.play(name, force, reversed, frame);
	}

	/**
		Adds an animation to the list
		@param name Name of this animation (Prefered style: `ANI_ANIMATION`, e.g. `ANI_ROLLING`)
	**/
	public function addAnim(name:String):Void {
		trace('Added animation to the list. (${animation.getByName(name)})'.info());
		Reflect.setField(exAnim, name, name);
	}

	public function animExists(name:String):Bool {
		if (Reflect.hasField(exAnim, name) || name != null) {
			var nameN:String = Std.string(Reflect.field(exAnim, name) ?? name);
			return (!StringUtil.isNull(nameN) && animation.getByName(nameN) != null);
		}

		trace('Animation "$name" doesn\'t exists in the list!'.warn());
		return false;
	}

	public function updateMoves() {
		acceleration.x = 0;

		var inputUP:Bool = false;
		var inputDOWN:Bool = false;
		var inputLEFT:Bool = false;
		var inputRIGHT:Bool = false;

		inputUP = controls.UP_P;
		inputDOWN = controls.DOWN_P;
		inputLEFT = controls.LEFT_P;
		inputRIGHT = controls.RIGHT_P;

		if (inputUP && inputDOWN) inputUP = inputDOWN = false;
		if (inputLEFT && inputRIGHT) inputLEFT = inputRIGHT = false;

		if (inputLEFT || inputRIGHT) {
			facing = (inputLEFT) ? LEFT : RIGHT;

			switch (facing) {
				case LEFT, RIGHT:
					if ((velocity.x != 0) && touching == NONE) playAnim("ANI_WALKING");

					acceleration.x = (facing == LEFT) ? -maxVelocity.x * 4 : maxVelocity.x * 4;
				case _:
			}
		}
		else {
			if (inputUP) {
				facing = UP;
				playAnim("ANI_LOOK_UP");
			}
			else if (inputDOWN) {
				facing = DOWN;
				playAnim("ANI_LOOK_DOWN");
			}
			else
				playAnim("ANI_STOPPED");

			velocity.x = velocity.y = 0;
		}

		// In PlayState, make action buttons act like jump buttons
		if (controls.JUMP || controls.ACCEPT || controls.BACK) {
			jump();
		}
	}

	public function jump() {
		if (velocity.y == 0) {
			CoolUtil.playSound("Jump");
		}
	}

	var deadBySpikes:Bool = false; // When player dies by spikes, the death sound is different. Maybe plays together with the normal sound?
	override public function kill() {
		velocity.y = velocity.x = 0;

		//CoolUtil.playSound("Hurt");
	}
}

typedef AnimData = {
	/**
		Name of the animation
	**/
	name:String,

	/**
		How should your animation be displayed?
	**/
	?displayName:String,

	/**
		How much spritesheets your animation use?
		Separated by comma (`,`)
	**/
	?sheets:String,

	/**
		Name in SparrowAtlas file
	**/
	?prefix:String,

	?fps:Float,

	/**
		Does this animation loops?
	**/
	?loop:Bool,

	/**
		Offset to apply in this animation
		*Only when it's played*
	**/
	?offset:Array<Int>,

	/**
		Frame indices to use
		You can sort here if needed
	**/
	?indices:Array<Int>
}

typedef CharacterData = {
/**
		Name of this character
		Used on IDs and results text
	**/
	name:String,

	/**
		A Custom character icon for the HUD
	**/
	?liveIcon:String,

	/**
		Color that this character uses
		Used for Normal palette showing, super, etc.
	**/
	palettes:Array<Array<String>>,

	/**
		Some characters doesn't achieve Super forms, so there you are!
		NOTE: If set to `true`, the live icon needs to have 2 frames!
	**/
	hasSuper:Bool,

	animations:Array<AnimData>,
	extraAnimations:Array<AnimData>,

	?hasSpindash:Bool
}

/**
	Contains default animations used by all characters

	Use `addAnim()` if you want to add a new one, or set them on the character JSON file in "extraAnimations" array
**/
enum abstract AnimList(String) from String to String {
	// I KNOW THAT ITS A LOT OF ANIMATIONS, but I will use them on the future, I guess... be patient!
	// Also, this animation list are gotten from the Retro Engine 4 (Sonic 2), so?...
	var ANI_STOPPED         = "ANI_STOPPED";
	var ANI_WAITING         = "ANI_WAITING";
	var ANI_BORED           = "ANI_BORED";
	var ANI_LOOK_UP         = "ANI_LOOK_UP";
	var ANI_LOOK_DOWN       = "ANI_LOOK_DOWN";
	var ANI_WALKING         = "ANI_WALKING";
	var ANI_RUNNING         = "ANI_RUNNING";
	var ANI_SKIDDING        = "ANI_SKIDDING";
	var ANI_SUPER_PEEL_OUT  = "ANI_SUPER_PEEL_OUT";
	var ANI_SPINDASH        = "ANI_SPINDASH";
	var ANI_JUMPING         = "ANI_JUMPING";
	var ANI_BOUNCING        = "ANI_BOUNCING";
	var ANI_HURT            = "ANI_HURT";
	var ANI_DYING           = "ANI_DYING";
	var ANI_DROWNING        = "ANI_DROWNING";
	var ANI_FAN_ROTATE      = "ANI_FAN_ROTATE";
	var ANI_BREATHING       = "ANI_BREATHING";
	var ANI_PUSHING         = "ANI_PUSHING";
	var ANI_FLAILING1       = "ANI_FLAILING1";
	var ANI_FLAILING2       = "ANI_FLAILING2";
	var ANI_FLAILING3       = "ANI_FLAILING3";
	var ANI_HANGING         = "ANI_HANGING";
	var ANI_GRABBED         = "ANI_GRABBED";
	var ANI_CLINGING_ON     = "ANI_CLINGING_ON";
	var ANI_TWIRL_H         = "ANI_TWIRL_H";
	var ANI_TWIRL_V         = "ANI_TWIRL_V";
	var ANI_WATER_SLIDE     = "ANI_WATER_SLIDE";
	var ANI_CONTINUE        = "ANI_CONTINUE";
	var ANI_CONTINUE_UP     = "ANI_CONTINUE_UP";
	var ANI_SUPER_TRANSFORM = "ANI_SUPER_TRANSFORM";
}
