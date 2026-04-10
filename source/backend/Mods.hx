package backend;
import polymod.Polymod;
import polymod.Polymod.Framework;

class Mods {
	inline public static final MOD_ROOT:String = #if debug "../../../../" + #end "mods";
	#if mac MOD_ROOT = '../../../$MOD_ROOT'; #end

	public static var cachedMods:Array<ModMetadata> = null;

	public static function loadMods(ids:Array<String>):Void {
		trace((ids.length == 0) ? "Guess what? Loaded no mods!" : 'Woo! Loaded ${ids.length} mods!');

		Polymod.onError = getError;

		Polymod.init({
			modRoot: MOD_ROOT,
			dirs: ids,
			framework: Framework.OPENFL,
			useScriptedClasses: true,
			firetongue: Main.tongue
		});
	}

	public static function getAll(?getErrors:Bool = true):Array<ModMetadata> {
		if (getErrors)
			Polymod.onError = getError;

		var list:Array<ModMetadata> = Polymod.scan({
			modRoot: MOD_ROOT
		});

		return list;
	}

	public static function getAllIds():Array<String> {
		var dump:Array<String> = [for (i in getAll()) i.id];
		return dump;
	}

	public static function getError(e:PolymodError):Void {
		function error(m:Dynamic) { trace('[POLYMOD:ERROR] $m'); }
		function warn(m:Dynamic)  { trace('[POLYMOD:WARN] $m'); }
		function log(m:Dynamic)   { trace('[POLYMOD:INFO] $m'); }

		switch (e.code) {
			case PolymodErrorCode.MOD_LOAD_PREPARE, PolymodErrorCode.MOD_LOAD_DONE,
				PolymodErrorCode.SCRIPT_PARSED:
				return;
			case PolymodErrorCode.MOD_LOAD_FAILED:
				error('Failed to load mod: ${e.message}');
			case PolymodErrorCode.MISSING_ICON:
				warn('A mod is missing an icon!');
			case PolymodErrorCode.MERGE:
				error('Failed to merge file! ${e.message}');
			case PolymodErrorCode.APPEND:
				error('Failed to append file! ${e.message}');
			case PolymodErrorCode.MISSING_MOD:
				error('Tried to load a mod that doesn\'t exists! ${e.message}');
			case PolymodErrorCode.VERSION_CONFLICT_API:
				warn('Tried to load a mod, but this uses an old API version! ${e.message}');
			case PolymodErrorCode.SCRIPT_PARSE_ERROR:
				error('Failed to parse script: ${e.message}');
			case PolymodErrorCode.SCRIPT_HSCRIPT_NOT_INSTALLED:
				warn('Game says that support scripting but HaxeScript is not installed at all.');
			case PolymodErrorCode.SCRIPT_CLASS_MODULE_BLACKLISTED:
				warn('You can\'t use ${e.message} -> It was blacklisted.');
			default:
					 if (e.severity == PolymodErrorType.ERROR)   { error(e.message); }
				else if (e.severity == PolymodErrorType.WARNING) {  warn(e.message); }
				else if (e.severity == PolymodErrorType.NOTICE)  {   log(e.message); }
		}
	}

}