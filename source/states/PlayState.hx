package states;

import objects.Character;
import objects.LifeIcon;
import game.HudGame;

class PlayState extends StateManager {
	public static var instance:PlayState;

	public var player:Character = null;
	public var hud:HudGame = null;

	public var camGame:FlxCamera;
	public var camFront:FlxCamera;
	public var camHUD:FlxCamera;

	public var uiGroup:FlxSpriteGroup;

	override public function create() {
		instance = this;

		player = new Character(50, 50, Character.defaultPlayer);

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

		hud = new HudGame(8, 10);

		CoolUtil.playMusic("GreenHill1");
	}

	override public function update(elapsed:Float) {
		if (FlxG.keys.justPressed.SIX) {
			hud.rings += 10;
			CoolUtil.playSound("Ring");
		}

		if (FlxG.keys.justPressed.EIGHT) {
			player.isSuper = true;
			player.curPalette++;
		}

		player.updateMoves();
		super.update(elapsed);

		if (controls.PAUSE) openPauseMenu();
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
