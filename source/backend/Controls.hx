package backend;

import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.gamepad.mappings.FlxGamepadMapping;
import flixel.input.keyboard.FlxKey;

class Controls {
	//Gamepad & Keyboard stuff
	public var keyboardBinds:Map<String, Array<FlxKey>>;
	public var gamepadBinds:Map<String, Array<FlxGamepadInputID>>;


	public function justPressed(key:String) {
		var result:Bool = (FlxG.keys.anyJustPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadJustPressed(gamepadBinds[key]) == true;
	}

	/**
		Rumble a controller or vibrate on mobile
		@param low (Strong) Low Frequence motor, period if on mobile
		@param high (Weak) High frequence motor.
		@param duration Duration of the vibration
		@author Sunnydev31
	**/
	public function vibrate(low:Float, high:Float, duration:Int) {
		#if (lime >= "8.3.0")
		if (controllerMode) {
			for (id in lime.ui.Gamepad.devices.keys()) {
				var pad = lime.ui.Gamepad.devices.get(id);
				if (pad != null) {
					trace('Vibrating gamepad! ($low, $high, $duration)');
					return pad.rumble(low, high, duration);
				}
			}
		}
		#elseif mobile
		trace('Vibrating as Haptics (${Std.int(high)}', '$duration)');
		return lime.ui.Haptic.vibrate(Std.int(high), duration);
		#else
		trace("Tried to vibrate a device, but platform is not compatible!");
		return;
		#end
	}

	public function pressed(key:String) {
		var result:Bool = (FlxG.keys.anyPressed(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadPressed(gamepadBinds[key]) == true;
	}

	public function justReleased(key:String) {
		var result:Bool = (FlxG.keys.anyJustReleased(keyboardBinds[key]) == true);
		if(result) controllerMode = false;

		return result || _myGamepadJustReleased(gamepadBinds[key]) == true;
	}

	public var controllerMode:Bool = false;
	private function _myGamepadJustPressed(keys:Array<FlxGamepadInputID>):Bool {
		if(keys != null) {
			for (key in keys) {
				if (FlxG.gamepads.anyJustPressed(key) == true) {
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadPressed(keys:Array<FlxGamepadInputID>):Bool {
		if(keys != null) {
			for (key in keys) {
				if (FlxG.gamepads.anyPressed(key) == true) {
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}
	private function _myGamepadJustReleased(keys:Array<FlxGamepadInputID>):Bool {
		if(keys != null) {
			for (key in keys) {
				if (FlxG.gamepads.anyJustReleased(key) == true) {
					controllerMode = true;
					return true;
				}
			}
		}
		return false;
	}

	public var UP(get, never):Bool;
	public var DOWN(get, never):Bool;
	public var LEFT(get, never):Bool;
	public var RIGHT(get, never):Bool;

	public var AUX(get, never):Bool;
	public var JUMP(get, never):Bool;
	public var BACK(get, never):Bool;
	public var ACCEPT(get, never):Bool;
	
	private function get_UP()		return justPressed("up");
	private function get_DOWN()		return justPressed("down");
	private function get_LEFT()		return justPressed("left");
	private function get_RIGHT()	return justPressed("right");
	
	private function get_AUX()		return justPressed("auxiliar");
	private function get_JUMP()		return justPressed("jump");
	private function get_BACK()		return justPressed("back");
	private function get_ACCEPT()	return justPressed("accept");

	// IGNORE THESE
	public static var instance:Controls;
	public function new() {
		keyboardBinds = ClientPrefs.keyBinds;
		gamepadBinds = ClientPrefs.gamepadBinds;
	}
}