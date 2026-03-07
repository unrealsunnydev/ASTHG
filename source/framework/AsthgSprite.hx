/**
	Sunnydev31 - 2025-12-22
	You are allowed to use, modify and redistribute this code
	But give credit where credit is due!
**/

package framework;

import flixel.FlxSprite;
import flixel.addons.display.FlxSliceSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.math.FlxRect;
import flixel.math.FlxPoint;

/**
	Custom instance for FlxSprite with better functions

	Example:	
	```haxe
	var mySprite:AsthgSprite = new AsthgSprite();
	mySprite.create("My Sprite"); // calls `loadGraphic(Paths.image("My Sprite"));`
	```
**/
class AsthgSprite extends FlxSprite {

	public function new(?x:Float = 0, ?y:Float = 0.0) {
		super(x, y);
	}

	/**
		Creates a simple sprite
		@param pos Position of the sprite
		@param image The image to load
		@return AsthgSprite
	**/
	public static function create(x:Float = 0, y:Float = 0, image:Null<String>):AsthgSprite {
		var spr:AsthgSprite = new AsthgSprite(x, y);

		if (!StringUtil.isNull(image))
			spr.loadGraphic(Paths.image(image));
		else {
			trace("[create] 'image' argument is null!");
			spr.loadGraphic(flixel.system.FlxAssets.getBitmapData("flixel/images/logo/default"));
		}

		return spr;
	}

	public static function createSpriteSheet(x:Float = 0, y:Float = 0, fWidth:Int, fHeight:Int, image:Null<String> = null):AsthgSprite {
		var spr:AsthgSprite = new AsthgSprite(x, y);

		if (!StringUtil.isNull(image))
			spr.loadGraphic(Paths.image(image), true, fWidth, fHeight);
		else {
			trace("[create] 'image' argument is null!");
			spr.loadGraphic(flixel.system.FlxAssets.getBitmapData("flixel/images/logo/default"));
		}

		return spr;
	}

	/**
		Create a new SparrowAtlas V2 sprite.
		@param x Horizontal position.
		@param y Vertical position
		@param image Image name
		@return AsthgSprite
	**/
	public static function createSparrow(x:Float = 0, y:Float = 0, image:Null<String> = null):AsthgSprite {
		var spr:AsthgSprite = new AsthgSprite(x, y);

		if (!StringUtil.isNull(image)) {
			spr.frames = Paths.getSparrowAtlas(image);
		}
		else {
			trace("[createSparrow] 'image' argument is null!");
			spr.loadGraphic(flixel.system.FlxAssets.getBitmapData("flixel/images/logo/default"));
		}

		return spr;
	}

	// Just calls FlxGradient, lol
	public static function createGradient(width:Int, height:Int, ?colors:Array<FlxColor>, ?chuncks:UInt = 2, ?angle:Int = 0, ?interp:Bool = true):FlxSprite {
		var spr:FlxSprite = new FlxSprite(); // We need to use FlxSprite here because FlxGradient returns that
		spr = FlxGradient.createGradientFlxSprite(width, height, colors, chuncks, angle, interp);
		return spr;
	}

	public function createGraphic(width:Float = 1, height:Float = 1, color:FlxColor = FlxColor.WHITE):AsthgSprite {
		var graph:FlxGraphic = FlxG.bitmap.create(2, 2, color, false, 'graphic($width,$height,#${color.toWebString()})');
		frames = graph.imageFrame;
		scale.set(width / 2, height / 2);
		updateHitbox(); // We can't use our tool because it's not a FlxSprite-type
		return this;
	}

	/**
		Creates a 9-Sliced sprite!
		@param x Position horizontally
		@param y Vertical position
		@param width Width to final sprite
		@param height Height to final sprite
		@param image The image stored in "images/"
		@param slice Slice parameters (Left, Top, Spaces from Left, Spaces from Top)
		@param imageRect The image part you want to crop
		@return FlxSliceSprite
	**/
	public static function createSliced(x:Float, y:Float, width:Float, height:Float, image:String, slice:Array<Int>, ?imageRect:Array<Int>):FlxSliceSprite {
		// FINALLY I GOT IT HOW THIS THING WORKS -- @sunnydev31
		var sliceSprite:FlxSliceSprite = new FlxSliceSprite(Paths.image(image),
			FlxRect.get(slice[0], slice[1], slice[2], slice[3]), width, height,
			FlxRect.get(imageRect[0], imageRect[1], imageRect[2], imageRect[3]));
		sliceSprite.setPosition(x, y);
		return sliceSprite;
	}
	
	/**
		Switches a global color into a custom color	
		Note that the sprite must be added or loaded to work
		The global color is stores at `backend.Constants` -> PALETTE_OVERRIDE

		@param pal The colors to replace in order, Must match the length of the for-loop on the function
		@return AsthgSprite
	**/
	public function applyPalette(pal:Array<FlxColor>):AsthgSprite {
		for (i in 0...Constants.PALETTE_OVERRIDE.length) {
			replaceColor(Constants.PALETTE_OVERRIDE[i], pal[i]);
		}

		return this;
	}

	/**
		Scales a sprite to a specific width and height
		@param width The target width
		@param height The target height
		@param updateHitbox Whether to update the hitbox after scaling
		@return AsthgSprite
	**/
	public function scaleSet(width:Float, height:Float, ?updHitbox:Bool = true):Void {
		scale.set(width, height);
		if (updHitbox) updateHitbox();
	}
}