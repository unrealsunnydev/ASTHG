@{ # Culture: 'en-US'
	Done = "Done."
	Finished = "Finished."
	PausePrompt = "Press any key to continue. . ." # Command prompt style message

	InstallingDependencies = @{
		Default = "Installing dependencies."
		Android = "Installing additional Android dependencies."
		AndroidTools = "Installing Android Tools v{0}"

		SubText = "This might take a few moments depending on your internet speed."
		HaxeWarn = "Make sure Haxe is installed and added to your PATH environment variable."
	}

	CheckinGit = "Checking if git is installed..."
	GitInstalledPrompt = "Do you have Git installed? ({0}/{1})"
	GitSkippedPrompt = "Skipped libraries where Git is needed (you can install them later manually)."

	NotHaxe = "Haxelib was not found!`nIs '%HAXEPATH%' and '%NEKO_INSTPATH%' registered on your PATH?"
	GetHaxePath = "Please, insert the location of your HaxeToolkit folder path."

	InstallingMSVC = @{
		Prompt = "Installing Microsoft Visual Studio BuildTools (Dependency)"
		ErrorDownload = "The download of VS BuildTools has failed: {0}"
		ErrorPath = "'{0}' was not found. Returning..."
	}

	UnsupportedPS = "You're using an older version of PowerShell`nPlease. Use PowerShell Core (6.0+), having in mind that it supports Unix-like systems."

	Menu = @{
		Title = "ASTHG Setup"
		Options = @(
			"Install default dependencies",
			"Setup for Windows",
			"Setup for MacOS",
			"Setup for Android",
			"Remove setup files",
			"Exit"
		)
		Prompt = "Choose an option ({0}/{1})"
		Error = "Invalid option, please try again."
		ErrorOS = "This option is not available for your system."
		NotAvailable = "This option is disabled because HaxeLib was not found."
	}

	yOption = "y" # 'Yes' option.
	nOption = "n" # 'No' option.

	RemoveSetup = @{
		Dependencies = "Removing dependencies..."
		LibraryDependencies = "Removing library dependencies..."
		InfoAndroid = "Checking for Android setup..."
		NotAndroid = "Android configuration not found."
		AndroidWarn = "WARNING: This will delete your Lime configuration file entirely!`nContinue? ({0}/{1})"
	}

	# Don't ask this
	DummyFile = "Don't delete this file!`nIt is used for setup script."

	NotAvailable = "Sorry, this option is not available for now."

	Config = @{
		FailedSave = "Failed to save config: {0}"
	}
}