#requires -PSEdition Core
#requires -Version 6

# ^^^^^^ Kinda be ridiculous, but this is for a maniac who will try to run this on PowerShell 4 or something.
# By that, WHY ARE YOU RUNNING ON AN OUTDATED PS VERSION???????????

param(
	[string]$Is32Bits,
	[string]$Action,
	[string]$Platform,
	[string]$BuildType,
	[string[]]$BuildFlags
)

# Import translations folders if available
Import-LocalizedData -BindingVariable "Msg" -ErrorAction Stop

$Host.UI.RawUI.WindowTitle = $Msg.Title
Clear-Host

# Checker for Haxelib + Stops running if not found
$haxelib = if (-not (Get-Command "haxelib" -ErrorAction SilentlyContinue)) {
	Join-Path (Read-Host ($Msg.InsertHaxelib).Join("`n")) "haxelib"
}
else { Get-Command "haxelib" -ErrorAction Stop }

# Start with default settings if not called on PowerShell terminal
# CPP -> Windows / Linux / MacOS (depends on host)
if ([string]::IsNullOrEmpty($Platform)) { $Platform	= if ($IsWindows -or $IsLinux -or $IsMacOS) { "cpp" } else { "hl" } }
if ([string]::IsNullOrEmpty($Action)) { $Action = "build" }
if ([string]::IsNullOrEmpty($BuildType)) { $BuildType = "release" }
if ([string]::IsNullOrEmpty($Is32Bits)) { $Is32Bits = "false" }

$Is32Bits = ($Is32Bits -in @("y", "yes", "true", "1"))

$hxArgs = @("run", "lime", $Action, $Platform, "-$BuildType")

<#
	.DESCRIPTION
	Function to simulate the "pause" command on Command Prompt on Windows.

	.NOTES
	This function calls "Command Prompt" if you're using Windows.
#>
function Set-Pause {
	if ($IsWindows) { & "cmd.exe" "/c" "pause" }
	else {
		Write-Host ($Msg.PausePrompt)
		[void][System.Console]::ReadKey($true)
	}
}

# Set the cwd to "ASTHG"
Set-Location "$PSScriptRoot/../../"

# If arguments are available, add them
if (-not [string]::IsNullOrEmpty($BuildFlags)) {
	$hxArgs += $BuildFlags
}

# Draw config info and pause
foreach ($srt in $Msg["Config"].Keys) {
	$val = Get-Variable -Name $srt -ValueOnly
	Write-Host ($Msg.Config[$srt] -f "$val".toLower())
}
Set-Pause

# User confirmed, ready to go!
Clear-Host
Write-Host ($Msg.BuildTexts["$Action"])
& $haxelib @hxArgs

Set-Pause

if ($Action -in @("build")) {
	$expPath = switch ($Platform) {
		default {
			"export/$BuildType/$(if ($IsWindows) { "windows" } elseif ($IsLinux -or $IsMacOS) { "neko" })/bin"
		}
		"android" {
			"export/$BuildType/android/bin/app/build/outputs/apk" # It's a long path! Dontcha think? (More than Machintosh lol)
		}
	}
}

Start-Process (if ($IsWindows) { "explorer" } elseif ($IsLinux) { "xdg-open" } elseif ($IsMacOS) { "open" }) -ArgumentList $expPath