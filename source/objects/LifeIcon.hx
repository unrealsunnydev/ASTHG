/**
	Sunnydev31 - 2025-12-22
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
**/

package objects;

class LifeIcon extends AsthgSprite {
	var charObj:Character;
	public function new(char:String) {
		super();

		charObj = states.PlayState.instance?.player;

		init(char);
		animation.play("normal");

		scrollFactor.set();
	}

	/**
		Life icons!

		@param char Cur character
	**/
	public function init(char:String) {
		var img = 'characters/${charObj.json.name}/liveIcon';
		var strike:Bool = Paths.fileExists('images/$img.png', IMAGE);

		if (!strike) { // Strike 1: Char file not found -> Use JSON entry
			img = "characters/" + charObj.json.name + "/" + charObj.json.liveIcon;
			trace("Not found! Searching with JSON entry");
		}
	
		if (!strike) { //Strike 2: Char file with JSON name not found -> Use placeholder
			img = "characters/Sonic/liveIcon";
			trace("Not found again! Getting placeholder");
		}
	
		if (!strike)  //Strike 3: Impossible to find files to use / Even fallback was not found
			throw "Holy damn! WHAT DID YOU DO WITH YOUR ASSETS???????????";

		var graphic = Paths.image(img);

		loadGraphic(graphic, true, charObj.json.hasSuper ? Math.floor(graphic.width/2) : Math.floor(graphic.width), Math.floor(graphic.height));
		animation.add("normal", [0], 0, false, false);
		animation.add("super" , [1], 0, false, false);

		if (graphic.width > 17 && graphic.height > 17) { // Sonic CD styled
			this.scaleSet(17, 17);
		}
	}

	override function update(e:Float) {
		super.update(e);

		if (states.PlayState.instance != null)
			(charObj?.isSuper) ? animation.play("super") : animation.play("normal");
	}
}