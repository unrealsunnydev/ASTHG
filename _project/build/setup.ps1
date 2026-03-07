#requires -PSEdition Core
#requires -Version 7

param(
	[string]$StayOnMenu = ""
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
	if ($IsWindows) { & "cmd.exe" "/c" "pause" }
	else {
		Write-Output ($Msg.PausePrompt)
		[void][System.Console]::ReadKey($true)
	}
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

function Set-SetupConfig {
	param(
		[Parameter(Mandatory = $true, Position = 0)] [object]$Name,
		[Parameter(Mandatory = $true, Position = 1)] [object]$Value
	)

	$obj += @{ $Name = $Value }
	try {
		$obj | ConvertTo-Json | Set-Content -Path $ConfigPath -Encoding UTF8
	}
	catch { Write-Warning ($Msg.Config.FailedSave -f $_) }
}

if (-not $HasHaxelib) { Write-Output ($Msg.NotHaxe) }

function Set-SetupWindows {
	$filename = "vs_BuildTools.exe"
	$url = "https://aka.ms/vs/16/release/{0}"

	try {
		Invoke-WebRequest -Uri ($url -f $filename) -OutFile $filename
		Write-Output ($Msg.InstallingMSVC.Prompt)
	}
	catch {
		Write-Warning ($Msg.InstallingMSVC.ErrorDownload -f $_)
		return
	}

	if (Test-Path $filename) {
		try {
			Start-Process -FilePath $filename -ArgumentList "--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --passive --nocache --downloadThenInstall" -Wait
			Remove-Item $filename
		}
		catch {}
	}
	else {
		Write-Warning ($Msg.InstallingMSVC.ErrorPath -f $filename)
		return
	}

	Write-Output ($Msg.Finished)
	Set-Pause
	Clear-Host
}

function Set-SetupMacOS {
	Write-Output ($Msg.NotAvailable)
}

function Set-SetupAndroid {
	Write-Output ($Msg.InstallingDependencies.Android)
	Start-Sleep 2

	# Adds "extension-androidtools" to HMM Library list
	& "hmm" @("haxelib", "extension-androidtools")
	Start-Sleep 5

	& $Haxelib @("--never", "run", "lime", "setup", "android")
	Set-SetupConfig -Name SetupAndroid -Value $true
}

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

	Write-Output ($Msg.Finished)

	if ($StayOnMenu) { Set-Location $PSScriptRoot }
}

function Remove-GameSetup {
	Write-Output $Msg.RemoveSetup.Dependencies

	<#
		Search for Android setup
		If true, remove Android setup
	#>
	if ((Get-SetupConfig -Name SetupAndroid) -eq $true) {
		Write-Output ($Msg.RemoveSetup.Android)
		& "hmm" @("remove", "extension-androidtools") 
		Set-Pause

	}
	
	<#
		Search in config if setup has done or if ".haxelib" exists
		If true, remove ALL dependencies
	#>
	if (((Get-SetupConfig -Name SetupDone) -eq $true) -or (Test-Path "$PSScriptRoot/../../.haxelib")) {
		try { & "hmm" "clean" } catch {}
	}


	if (Test-Path $ConfigPath) {
		Remove-Item $ConfigPath -Force
	}

	Write-Output ($Msg.Finished)
}

do {
	Write-Output ("===== {0} =====" -f $Msg.Menu.Title)
	foreach ($i in 0..($Msg["Menu"]["Options"].Count - 1)) {
		switch ($i) {
			0 {
				Write-Output ("{0}. {1}" -f $i, ($HasHaxelib) ? $Msg.Menu.Options[$i] : $Msg.Menu.NotAvailableOpt)
				continue
			}
			4 {
				Write-Output ("{0}. {1}" -f $i, ($HasHaxelib) ? $Msg.Menu.Options[$i] : $Msg.Menu.NotAvailableOpt)
				continue
			}
			default { Write-Output ("{0}. {1}" -f $i, $Msg.Menu.Options[$i]); continue }
		}
	}
	Write-Output ""

	$choice = Read-Host ($Msg.Menu.Prompt -f 0, ($Msg["Menu"]["Options"].Count - 1))

	switch (($choice).ToString().ToLower()) {
		'0' { if ($HasHaxelib)	{ New-GameSetup		} }
		'1' { if ($IsWindows)	{ Set-SetupWindows	}	else { Write-Output ($Msg.Menu.ErrorOS) } }
		'2' { if ($IsMacOS)		{ Set-SetupMacOS	}	else { Write-Output ($Msg.Menu.ErrorOS) } }
		'3' { Set-SetupAndroid }
		'4' { if ($HasHaxelib)	{ Remove-GameSetup } }
		'5' { exit }
		'exit' { exit }
		default { Write-Output ($Msg.Menu.Error) }
	}
} while ($StayOnMenu.ToLower() -in @("y", "yes", "true", "1"))
Stop-Transcript
