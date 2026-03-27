#if !macro

import framework.*;

import backend.ClientPrefs;
import backend.Controls;
import backend.Constants;
import backend.CoolUtil;

#if DISCORD_ALLOWED
import backend.Discord;
#end

import backend.Locale;

#if MODS_ALLOWED
import backend.Mods;
#end

import backend.StateManager;
import backend.SubStateManager;
import backend.Paths;

import states.LoadingState;

import util.*;

using util.Ansi;
//---------------------------------//

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.text.FlxBitmapText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;

using StringTools;
#end