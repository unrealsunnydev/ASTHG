package game;

import states.PlayState;
import objects.LifeIcon;

/**
	Dedicated class to handle the HUD, making PlayState more cleaner and easier to manage.

	Also, this allows me to easily add more HUD elements and using dynamic
	functions for scripts, without leaving it all in PlayState, yay!
	@author Sunnydev31 (@unreal.sunnydev)
**/
class HudGame extends AsthgSprite {
	public static var instance:HudGame;

	/**
		Stores the player score, actually this follows the Sonic 3 & Knuckles system
		Where the score is multiplied by 10.
	**/
	public var score:Int = 0;

	/**
		Stores the current stage time, actually this is unused.
	**/
	public var time:String = "0:00";

	/**
		what.
	**/
	public var timeVal:Float = 0;

	/**
		Stores the P1 rings, actually this is unused... Or not?...
	**/
	public var rings:Int = 0;

	/**
		Stores the player lives, and you know the rest of this description.
	**/
	public var lives:Int = 3;


	// --- DRAWABLE HUD ELEMENTS --- //

	/**
		"SCORE" text element.
	**/
	public var scoreTxt:FlxBitmapText;

	/**
		"TIME" text element.
	**/
	public var timeTxt:FlxBitmapText;

	/**
		"RINGS" text element.
	**/
	public var ringsTxt:FlxBitmapText;

	/**
		Readable lives counter.
		This follows the style based on 8-bit games.
	**/
	public var livesTxt:FlxBitmapText;

	// --- READABLE HUD VALUES --- //

	/*	These are only used to show the values on the screen
		They don't need a description, do they?...			*/

	public var scoreValTxt:FlxBitmapText;
	public var timeValTxt:FlxBitmapText;
	public var ringsValTxt:FlxBitmapText;
	public var livesValTxt:FlxBitmapText;

	// --- DEBUG ONLY --- //

	/**
		Debug sprite to show the player X position.
	**/
	public var posX:AsthgSprite;

	/**
		Debug sprite to show the player Y position.
	**/
	public var posY:AsthgSprite;

	public var posXTxt:FlxBitmapText;
	public var posYTxt:FlxBitmapText;

	/**
		Instance used to show the player life icon.
	**/
	public var livesIcon:LifeIcon;

	/**
		Cronstructor for the HUD, remind to use a instance variable!
		@param x HUD Horizontal position, DEBUG sprites doesn't follow this.
		@param y HUD Vertical position, Life sprites doesn't follow this.
	**/
	public function new(x:Float, y:Float) {
		super(x, y);
		instance = this;

		createScoreHud(x, y);
		createTimeHud(x, y);
		createRingsHud(x, y);

		createLivesHud(x, FlxG.height - 26);

		createDebugHud(FlxG.width - 60, y);
	}

	public dynamic function createScoreHud(?x:Float = 0, ?y:Float = 0) {
		scoreTxt = new FlxBitmapText(x, y, Locale.getString("hud_text_score"), Paths.getAngelCodeFont("HUD"));
		scoreTxt.scrollFactor.set();

		scoreValTxt = new FlxBitmapText(scoreTxt.x + scoreTxt.width + 37, scoreTxt.y, '', Paths.getAngelCodeFont("HUD"));
		scoreValTxt.scrollFactor.set();
		scoreValTxt.x -= (scoreValTxt.width);

		PlayState.instance.uiGroup.add(scoreTxt);
		PlayState.instance.uiGroup.add(scoreValTxt);
	}

	public dynamic function createTimeHud(?x:Float = 0, ?y:Float = 0) {
		var timeTxt:FlxBitmapText = new FlxBitmapText(x, y + 16, Locale.getString("hud_text_time"), Paths.getAngelCodeFont("HUD"));
		timeTxt.scrollFactor.set();

		timeValTxt = new FlxBitmapText(timeTxt.x + timeTxt.width + 37, timeTxt.y, '', Paths.getAngelCodeFont("HUD"));
		timeValTxt.scrollFactor.set();
		timeValTxt.x -= (timeValTxt.width);

		PlayState.instance.uiGroup.add(timeTxt);
		PlayState.instance.uiGroup.add(timeValTxt);
	}

	public dynamic function createRingsHud(?x:Float = 0, ?y:Float = 0) {
		var ringsTxt:FlxBitmapText = new FlxBitmapText(x, y + 32, Locale.getString("hud_text_rings"), Paths.getAngelCodeFont("HUD"));
		ringsTxt.scrollFactor.set();

		ringsValTxt = new FlxBitmapText(ringsTxt.x + ringsTxt.width + 37, ringsTxt.y, '', Paths.getAngelCodeFont("HUD"));
		ringsValTxt.scrollFactor.set();
		ringsValTxt.x -= (ringsValTxt.width);

		PlayState.instance.uiGroup.add(ringsTxt);
		PlayState.instance.uiGroup.add(ringsValTxt);
	}

	public dynamic function createDebugHud(?x:Float = 0, ?y:Float = 0) {
		#if debug
		posX = AsthgSprite.create(x, y, "HUD/posX");
		posX.color = FlxColor.YELLOW;
		PlayState.instance.uiGroup.add(posX);

		posXTxt = new FlxBitmapText(posX.x + posX.width + 1, posX.y, '', Paths.getAngelCodeFont("HUD"));
		PlayState.instance.uiGroup.add(posXTxt);

		posY = AsthgSprite.create(posX.x, y + 13, "HUD/posY");
		posY.color = FlxColor.YELLOW;
		PlayState.instance.uiGroup.add(posY);

		posYTxt = new FlxBitmapText(posY.x + posY.width + 1, posY.y, '', Paths.getAngelCodeFont("HUD"));
		PlayState.instance.uiGroup.add(posYTxt);
		#end
	}

	/**
		Creates the lives HUD element (Live counter and icon)

		@param x Horizontal position on screen, default is 0
		@param y Vertical position on screen, default is 0
	**/
	public dynamic function createLivesHud(?x:Float = 0, ?y:Float = 0) {
		livesIcon = new LifeIcon(PlayState.instance.player.lifeIcon);
		livesIcon.setPosition(x, y);

		livesTxt = new FlxBitmapText(livesIcon.x + livesIcon.frameWidth + 1, livesIcon.y + 3, 'livesTxt', Paths.getAngelCodeFont("HUD"));
		livesTxt.scrollFactor.set();

		PlayState.instance.uiGroup.add(livesIcon);
		PlayState.instance.uiGroup.add(livesTxt);
	}

	override public function update(e:Float) {
		rings = Std.int(FlxMath.wrap(rings, 0, 999));
		lives = Std.int(FlxMath.wrap(lives, 0, 99));

		scoreTxt.text = Std.string(score);
		timeTxt.text = Std.string(time);
		ringsTxt.text = Std.string(rings);
		livesTxt.text = Std.string(lives);

		#if debug
		posXTxt.text = StringTools.hex(Std.int(PlayState.instance.player.x), 6);
		posYTxt.text = StringTools.hex(Std.int(PlayState.instance.player.y), 6);

		posX.color = (PlayState.instance.player.x >= 0xFFFF) ? 0xFFFF0000 :  0xFFFFFF00;
		posY.color = (PlayState.instance.player.y >= 0xFFFF) ? 0xFFFF0000 :  0xFFFFFF00;
		#end
	}
}