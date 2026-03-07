package tools;

import sys.io.File;
import sys.FileSystem;

using haxe.io.Path;
using StringTools;

class Postbuild {
	var buildStats:Map<String, Dynamic>;
	var file = File.getContent("tools/build.txt").split("\n");


	static function main() {
		for (i in file) {
			buildStats.set(i.trim().split("=")[0], i.trim().split("=")[1]);

			if (buildStats.exists(i.trim().split("=")[0])) trace("Added '" + i.trim().split("=")[0] + "'");
		}


		if (Sys.systemName() == "Windows" && buildStats.get("WINDOWS.VISUALELEMENTS") == true) {
			final CWD = Sys.getCwd().replace("/", "\\");
			//Creates a new PRI file for Windows Visual Elements
			// This is one step! The next one need to be manually done (embed the game into a Appx package)
			// YOU can copy Appxmanifest.xml from Lime WinRT samples, paste on export path, edit and then
			// call "Add-AppxPackage" with Powershell 5.1 (this cmdlet fails with PS Core)

			Sys.command("cls");
			final makepri:String = Path.withExtension("C:\\Program Files (x86)\\Windows Kits\\10\\bin\\10.0.19041.0\\x64\\makepri", "exe");
			var buildType:String = buildStats.get("BUILD"); // I wonder if I can get the build type from the Project.hxp?
			final exportPath:String = Path.directory(CWD + 'export\\$buildType\\windows\\bin\\');
			
			trace("Export path is " + exportPath);
			
			trace("\nCreating 'priconfig.xml', Maybe this is buggy because its called by Haxe\nPress [Y] to overrride existing config or any other key to cancel");
			Sys.command(makepri, ["createconfig", "/cf", Path.withExtension(exportPath + "\\priconfig", "xml"), "/dq", "en-US"]);

			trace("\nCreating 'resources.pri', Maybe this is buggy because its also called by Haxe\nPress [Y] to overrride existing resources or any other key to cancel");
			Sys.command(makepri, ["new", "/pr", exportPath, "/cf", Path.withExtension(exportPath + "\\priconfig", "xml")]);

			Sys.command("move", ["/y", Path.withExtension(CWD + exportPath +"resources", "pri"), Path.withExtension(CWD + exportPath +"resources", "pri")]);
		}
		
	}
}
