package states;

import objects.Character;
import objects.LifeIcon;

class PlayState extends StateManager {
	public static var instance:PlayState;

	public var score:Int = 10;
	var time:String = "0:00";
	var timeVal:Float = 0;
	var rings:Int = 0;
	var lives:Int = 3;
	
	var scoreTxt:FlxBitmapText;
	var timeTxt:FlxBitmapText;
	var ringsTxt:FlxBitmapText;
	var livesTxt:FlxBitmapText;

	public var hudPos:flixel.math.FlxPoint;

	public var camGame:FlxCamera;
	public var camFront:FlxCamera;
	public var camHUD:FlxCamera;

	public var uiGroup:FlxSpriteGroup;

	#if debug
	var posX:AsthgSprite;
	var posY:AsthgSprite;
	var posXTxt:FlxBitmapText;
	var posYTxt:FlxBitmapText;
	#end

	public var player:Character = null;

	public var livesIcon:LifeIcon;

	override public function create() {
		instance = this;

		player = new Character(50, 50, Character.defaultPlayer);

		hudPos = new flixel.math.FlxPoint(8,10);

		#if DISCORD_ALLOWED
		DiscordClient.changePresence(Locale.getString('playing', "discord"), Locale.getString("playing-player", "discord", [player.json.name]), "icon", "", player.json.name.toLowerCase(), player.json.name);
		#end
		Paths.clearStoredMemory();

		camGame = new FlxCamera();
		camGame.visible = true;
		FlxG.cameras.add(camGame);

		camHUD = new FlxCamera();
		camHUD.visible = !ClientPrefs.data.hideHud;
		camHUD.bgColor.alpha = 0; //I hate this so much
		FlxG.cameras.add(camHUD, false);

		camFront = new FlxCamera();
		camFront.visible = true;
		camFront.bgColor.alpha = 0;
		FlxG.cameras.add(camFront, false);
		

		//playTitleCard(["#000236", "#ffff00", "#ff0000"]);

		uiGroup = new FlxSpriteGroup();
		uiGroup.cameras = [camHUD];
		add(uiGroup);
		
		// Player init
		add(player);
		camGame.follow(player, TOPDOWN, 1);
		super.create();

		var scoreHud:FlxBitmapText = new FlxBitmapText(hudPos.x, hudPos.y, Locale.getString("hud_text_score"), Paths.getAngelCodeFont("HUD"));
		scoreHud.scrollFactor.set();
		uiGroup.add(scoreHud);
		
		var timeHud:FlxBitmapText = new FlxBitmapText(hudPos.x, hudPos.y + 16, Locale.getString("hud_text_time"), Paths.getAngelCodeFont("HUD"));
		timeHud.scrollFactor.set();
		uiGroup.add(timeHud);

		var ringsHud:FlxBitmapText = new FlxBitmapText(hudPos.x, hudPos.y + 32, Locale.getString("hud_text_rings"), Paths.getAngelCodeFont("HUD"));
		ringsHud.scrollFactor.set();
		uiGroup.add(ringsHud);

		scoreTxt = new FlxBitmapText(scoreHud.x + scoreHud.width + 37, scoreHud.y, '', Paths.getAngelCodeFont("HUD"));
		scoreTxt.scrollFactor.set();
		scoreTxt.x -= (scoreTxt.width);
		timeTxt = new FlxBitmapText(timeHud.x + timeHud.width + 37, timeHud.y, '', Paths.getAngelCodeFont("HUD"));
		timeTxt.scrollFactor.set();
		timeTxt.x -= (timeTxt.width);

		ringsTxt = new FlxBitmapText(ringsHud.x + ringsHud.width + 37, ringsHud.y, '', Paths.getAngelCodeFont("HUD"));
		ringsTxt.scrollFactor.set();
		ringsTxt.x -= (ringsTxt.width);

		ringsTxt.x = timeTxt.x = scoreTxt.x;

		uiGroup.add(scoreTxt);
		uiGroup.add(timeTxt);
		uiGroup.add(ringsTxt);

		livesIcon = new LifeIcon(player.lifeIcon);
		livesIcon.setPosition(hudPos.x, FlxG.height - 26);
		uiGroup.add(livesIcon);
		
		livesTxt = new FlxBitmapText(livesIcon.x + livesIcon.frameWidth + 1, livesIcon.y + 3, 'livesTxt', Paths.getAngelCodeFont("HUD"));
		livesTxt.scrollFactor.set();
		uiGroup.add(livesTxt);

		#if debug
		posX = AsthgSprite.create(FlxG.width - 60, hudPos.y, "HUD/posX");
		posX.color = 0xFFFFFF00;
		uiGroup.add(posX);

		posXTxt = new FlxBitmapText(posX.x + posX.width + 1, posX.y, '', Paths.getAngelCodeFont("HUD"));
		uiGroup.add(posXTxt);

		posY = AsthgSprite.create(posX.x, hudPos.y + 13, "HUD/posY");
		posY.color = 0xFFFFFF00;
		uiGroup.add(posY);
		
		posYTxt = new FlxBitmapText(posY.x + posY.width + 1, posY.y, '', Paths.getAngelCodeFont("HUD"));
		uiGroup.add(posYTxt);
		#end

		CoolUtil.playMusic("GreenHill1");
	}

	override public function update(elapsed:Float) {
		rings = Std.int(FlxMath.wrap(rings, 0, 999));
		lives = Std.int(FlxMath.wrap(lives, 0, 99));

		scoreTxt.text = Std.string(score);
		timeTxt.text = Std.string(time);
		ringsTxt.text = Std.string(rings);
		livesTxt.text = Std.string(lives);
		
		#if debug
		posXTxt.text = StringTools.hex(Std.int(player.x), 6);
		posYTxt.text = StringTools.hex(Std.int(player.y), 6);

		posX.color = (player.x >= 0xFFFF) ? 0xFFFF0000 :  0xFFFFFF00;
		posY.color = (player.y >= 0xFFFF) ? 0xFFFF0000 :  0xFFFFFF00;
		#end

		if (FlxG.keys.justPressed.SIX) { 
			rings += 10;
			CoolUtil.playSound("Ring");
		}

		if (FlxG.keys.justPressed.EIGHT) {
			player.isSuper = true;
			player.curPalette++;
		}

		player.updateMoves();
		super.update(elapsed);

		if (controls.justPressed('pause')) openPauseMenu();
	}

	function openPauseMenu() {
		FlxG.sound.music?.pause();

		openSubState(new substates.Pause());
	}

	/**
		Shows the title card
		@param colors Order: Background, Bottom Backdrop, Left backdrop
	**/
	public function playTitleCard(colors:Array<String>) {
		// Sonic 2 title card because yes

		var bg:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, 0xff000000);
		bg.cameras = [camFront];
		add(bg);

		var bg2:AsthgSprite = new AsthgSprite().createGraphic(FlxG.width, FlxG.height, FlxColor.fromString(colors[0]));
		bg2.cameras = [camFront];
		add(bg2);
		
		var backdrop2:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropX"), X);
		backdrop2.color = FlxColor.fromString(colors[1]);
		backdrop2.cameras = [camFront];
		backdrop2.y = FlxG.height - 50;
		add(backdrop2);

		var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image("UI/backdropY"), Y);
		backdrop.color = FlxColor.fromString(colors[2]);
		backdrop.cameras = [camFront];
		add(backdrop);

		var actName:FlxBitmapText = new FlxBitmapText(FlxG.width - 90, 87, "STAGE NAME", Paths.getAngelCodeFont("Roco"));
		actName.x -= actName.width;
		actName.cameras = [camFront];
		add(actName);

		var zoneName:FlxBitmapText = new FlxBitmapText(FlxG.width - 90, 105, "ZONE", Paths.getAngelCodeFont("Roco"));
		zoneName.x -= (zoneName.width);
		zoneName.cameras = [camFront];
		add(zoneName);

		FlxTween.tween(bg2, {y: FlxG.height}, 0.4);
		FlxTween.tween(backdrop, {y: FlxG.height - 50}, 0.5);
		FlxTween.tween(backdrop2, {x: 50}, 0.5);
	}
}
