package backend;
import polymod.Polymod;
import polymod.Polymod.Framework;

class Mods { 
	public static var list = Polymod.scan({
		modRoot: Constants.POLYMOD_SETTINGS.modRoot
	});

	public static function loadMods(): Void {
		Polymod.init({
			modRoot: Constants.POLYMOD_SETTINGS.modRoot,
			dirs:["pt-BR Translation"],
			framework: Framework.OPENFL,
			useScriptedClasses: false,
			#if firetongue
			firetongue: Main.tongue
			#end
		});
	}
}