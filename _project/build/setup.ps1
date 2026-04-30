#requires -PSEdition Core
#requires -Version 7.0

<#
	.SYNOPSIS
	Tool used for compiling the An Sonic the Hedgehog game

	.PARAMETER StayOnMenu
	If true, the script does not closes when it completes an action.
	Options: y, yes, true, 1

	.PARAMETER MenuOption
	If set, automatically starts an option from the menu without choosing

	Options: 0 to 5

	.EXAMPLE
	& setup.ps1 -MenuOption 0

	& setup.ps1 -StayOnMenu yes

	& setup.ps1 -StayOnMenu yes -MenuOption 3

	.NOTES
	Author: Sunnydev31 (@unreal.sunnydev)
	Latest edition: 2026/04/10
#>

param(
	[string]$StayOnMenu = "",
	[int]$MenuOption = -1
)

Import-LocalizedData -BindingVariable "Msg" -ErrorAction SilentlyContinue

# Change the title of the windows
$Host.UI.RawUI.WindowTitle = $Msg.Menu.Title

Start-Transcript -Path "$PSScriptRoot/setup.log"

<#
	.DESCRIPTION
	Function to simulate the "pause" command on Command Prompt on Windows.

	.NOTES
	This function calls "Command Prompt" if you're using Windows.
#>
function Set-Pause {
		Write-Output ($Msg.PausePrompt)
		[void][System.Console]::ReadKey($true)
}

# MAIN FUNCTION to call haxelib

[bool]$HasHaxelib = $false
if (Get-Command "haxelib" -ErrorAction SilentlyContinue) {
	$Haxelib = "haxelib"
	$HasHaxelib = $true
}

# Path to persist setup options
$ConfigPath = Join-Path $PSScriptRoot 'setup_config.json'
$obj = @{ }

<#
	.DESCRIPTION
	Function to get a setup configuration

	.OUTPUTS
	Object
#>
function Get-SetupConfig {
	param([Parameter(Mandatory = $true)] [object]$Name)

	try {
		if (Test-Path $ConfigPath) {
			$obj = Get-Content $ConfigPath -Raw | ConvertFrom-Json -ErrorAction Stop
			return $obj[$Name]
		}
	}
	catch {}
}

<#
	.DESCRIPTION
	Function to save a setup configuration

	.OUTPUTS
	Void
#>
function Set-SetupConfig {
	param(
		[Parameter(Mandatory = $true, Position = 0)] [object]$Name,
		[Parameter(Mandatory = $true, Position = 1)] [object]$Value
	)

	$obj += @{ $Name = $Value }
	try {
		$obj | ConvertTo-Json | Set-Content -Path $ConfigPath -Encoding UTF8
	}
	catch {
		Write-Warning ($Msg.Config.FailedSave -f $_)
	}
}

if (-not $HasHaxelib) { Write-Output ($Msg.NotHaxe) }

<#
	.DESCRIPTION
	Function to start a Windows setup

	.OUTPUTS
	Void
#>
function Set-SetupWindows {
	$filename = "vs_BuildTools.exe"

	try {
		Invoke-WebRequest -Uri ("https://aka.ms/vs/16/release/{0}" -f $filename) -OutFile $filename
		Write-Output ($Msg.InstallingMSVC.Prompt)
	}
	catch {
		Write-Warning ($Msg.InstallingMSVC.ErrorDownload -f $_)
		return
	}

	try {
		if (Test-Path $filename) {
			Start-Process -FilePath $filename -ArgumentList "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --passive --nocache --downloadThenInstall" -Wait
			Remove-Item $filename
		}
	}
	catch {
		throw ($Msg.InstallingMSVC.ErrorPath -f $filename)
		Stop-Transcript
	}

	Write-Output ($Msg.Finished)
	Set-Pause
	Clear-Host
}

<#
	.DESCRIPTION
	Function to start a Machintosh OS setup

	.NOTES
	This function are disabled by now

	.OUTPUTS
	Custom Exception
#>
function Set-SetupMacOS {
	Write-Output ($Msg.NotAvailable)
}

<#
	.DESCRIPTION
	Function to start a Windows setup

	.NOTES
	This function only run `haxelib --never run lime setup android`
	And saves a config entry for this.
#>
function Set-SetupAndroid {
	& $Haxelib @("--never", "run", "lime", "setup", "android")
	Set-SetupConfig -Name SetupAndroid -Value $true
}

<#
	.DESCRIPTION
	Function to start a game setup
	Install dependencies and configure lime
#>
function New-GameSetup {
	Write-Output ($Msg.InstallingDependencies.Default)
	Set-Pause

	& $Haxelib @("--global", "install", "hmm")
	Start-Sleep 2

	Set-Location "$PSScriptRoot/../../"
	& $Haxelib @("--global", "run", "hmm", "setup")
	Start-Sleep 2

	& "hmm" "install"
	Set-SetupConfig -Name SetupDone -Value $true

	Start-Sleep 2
	& $Haxelib @("run", "lime", "setup")

	Write-Output ($Msg.Finished)

	if ($StayOnMenu) { Set-Location $PSScriptRoot }
}

<#
	.DESCRIPTION
	Function to remove setup of the game
#>
function Remove-GameSetup {
	Write-Output $Msg.RemoveSetup.Dependencies

	<#
		Search in config if setup has done or if ".haxelib" exists
		If true, remove ALL dependencies
	#>
	if (((Get-SetupConfig -Name SetupDone) -eq $true) -or (Test-Path "$PSScriptRoot/../../.haxelib")) {
		try { & "hmm" "clean" } catch { Stop-Transcript }
	}

	if (Test-Path $ConfigPath) {
		Remove-Item $ConfigPath -Force
	}

	Write-Output ($Msg.Finished)
}

do {
	Write-Output ("===== {0} =====" -f $Msg.Menu.Title)
	foreach ($i in 0..($Msg["Menu"]["Options"].Count - 1)) {
		if ($i -in ("0", "4")) {
			$text = if ($HasHaxelib) { $Msg.Menu.Options[$i] } else { $Msg.Menu.NotAvailableOpt }
			Write-Output ("{0}. {1}" -f $i, $text)
			continue
		}
		else {
			Write-Output ("{0}. {1}" -f $i, $Msg.Menu.Options[$i])
			continue
		}
	}
	Write-Output ""
	Write-Debug ""
	Write-Debug "CURRENT LOCATION: $(Get-Location)"
	Write-Debug ""

	if ($null -ne $MenuOption -and $MenuOption -ne -1) {
		$MenuOptionNow = $MenuOption
	}
	else {
		$MenuOptionNow = Read-Host ($Msg.Menu.Prompt -f 0, ($Msg["Menu"]["Options"].Count - 1))
	}

	switch ($MenuOptionNow) {
		"0" { if ($HasHaxelib)	{ New-GameSetup		} }
		"1" { if ($IsWindows)	{ Set-SetupWindows	}	else { Write-Output ($Msg.Menu.ErrorOS) } }
		"2" { if ($IsMacOS)		{ Set-SetupMacOS	}	else { Write-Output ($Msg.Menu.ErrorOS) } }
		"3" { Set-SetupAndroid }
		"4" { if ($HasHaxelib)	{ Remove-GameSetup } }
		"5" { exit }
		default { Write-Output ($Msg.Menu.Error) }
	}

} while ($StayOnMenu.ToLower() -in @("y", "yes", "true", "1") -or $MenuOption -eq -1)
Stop-Transcript
