//@see https://github.com/ShadowMario/FNF-PsychEngine/blob/main/source/backend/Controls.hx

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
	public var UP_R(get, never):Bool;
	public var UP_P(get, never):Bool;
	public var DOWN(get, never):Bool;
	public var DOWN_R(get, never):Bool;
	public var DOWN_P(get, never):Bool;
	public var LEFT(get, never):Bool;
	public var LEFT_R(get, never):Bool;
	public var LEFT_P(get, never):Bool;
	public var RIGHT(get, never):Bool;
	public var RIGHT_R(get, never):Bool;
	public var RIGHT_P(get, never):Bool;

	public var AUX(get, never):Bool;
	public var AUX_R(get, never):Bool;
	public var AUX_P(get, never):Bool;
	public var JUMP(get, never):Bool;
	public var JUMP_R(get, never):Bool;
	public var JUMP_P(get, never):Bool;
	public var BACK(get, never):Bool;
	public var BACK_R(get, never):Bool;
	public var BACK_P(get, never):Bool;
	public var ACCEPT(get, never):Bool;
	public var ACCEPT_R(get, never):Bool;
	public var ACCEPT_P(get, never):Bool;
	public var PAUSE(get, never):Bool;

	private function get_UP()       return justPressed("up");
	private function get_UP_R()     return justReleased("up");
	private function get_UP_P()     return pressed("up");
	private function get_DOWN()     return justPressed("down");
	private function get_DOWN_R()   return justReleased("down");
	private function get_DOWN_P()   return pressed("down");
	private function get_LEFT()     return justPressed("left");
	private function get_LEFT_R()   return justReleased("left");
	private function get_LEFT_P()   return pressed("left");
	private function get_RIGHT()    return justPressed("right");
	private function get_RIGHT_R()  return justReleased("right");
	private function get_RIGHT_P()  return pressed("right");

	private function get_AUX()      return justPressed("auxiliar");
	private function get_AUX_R()    return justReleased("auxiliar");
	private function get_AUX_P()    return pressed("auxiliar");
	private function get_JUMP()     return justPressed("jump");
	private function get_JUMP_R()   return justReleased("jump");
	private function get_JUMP_P()   return pressed("jump");
	private function get_BACK()     return justPressed("back");
	private function get_BACK_R()   return justReleased("back");
	private function get_BACK_P()   return pressed("back");
	private function get_ACCEPT()   return justPressed("accept");
	private function get_ACCEPT_R() return justReleased("accept");
	private function get_ACCEPT_P() return pressed("accept");
	private function get_PAUSE()   return justPressed("pause");

	// IGNORE THESE
	public static var instance:Controls;
	public function new() {
		keyboardBinds = ClientPrefs.keyBinds;
		gamepadBinds = ClientPrefs.gamepadBinds;
	}
}