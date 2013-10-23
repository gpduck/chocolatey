# chocolatey
# Copyright (c) 2011-Present Rob Reynolds
# Committers and Contributors: Rob Reynolds, Rich Siegel, Matt Wrock, Anthony Mastrean, Alan Stevens
# Crediting contributions by Chris Ortman, Nekresh, Staxmanade, Chrissie1, AnthonyMastrean, Rich Siegel, Matt Wrock and other contributors from the community.
# Big thanks to Keith Dahlby for all the powershell help! 
# Apache License, Version 2.0 - http://www.apache.org/licenses/LICENSE-2.0

## Set the culture to invariant
$currentThread = [System.Threading.Thread]::CurrentThread;
$culture = [System.Globalization.CultureInfo]::InvariantCulture;
$currentThread.CurrentCulture = $culture;
$currentThread.CurrentUICulture = $culture;

#Let's get Chocolatey!
$chocVer = '0.9.8.20'
$nugetChocolateyPath = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$nugetPath = (Split-Path -Parent $nugetChocolateyPath)
$nugetDataPath = Split-Path -Parent $nuGetPath
$nugetExePath = Join-Path $nugetDataPath 'bin'
$nugetLibPath = Join-Path $nugetDataPath 'lib'
$extensionsPath = Join-Path $nugetDataPath 'extensions'
$chocInstallVariableName = "ChocolateyInstall"
$nugetExe = Join-Path $nugetChocolateyPath 'nuget.exe'
$h1 = '====================================================='
$h2 = '-------------------------'
$globalConfig = ''
$userConfig = ''
$env:ChocolateyEnvironmentDebug = 'false'
$RunNote = "DarkCyan"
$Warning = "Magenta"
#$ErrorColor = "Red"
$Note = "Green"


#$DebugPreference = "SilentlyContinue"
#if ($debug) {
#  $DebugPreference = "Continue";
#  $env:ChocolateyEnvironmentDebug = 'true'
#}

#$installModule = Join-Path $nugetChocolateyPath (Join-Path 'helpers' 'chocolateyInstaller.psm1')
Import-Module Chocolatey\Helpers

# grab functions from files
Resolve-Path $nugetChocolateyPath\functions\*.ps1 | 
    ? { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }


# load extensions if they exist
if(Test-Path($extensionsPath)) {
  Write-Debug 'Loading community extensions'
  #Resolve-Path $extensionsPath\**\*\*.psm1 | % { Write-Debug "Importing `'$_`'"; Import-Module $_.ProviderPath }
  Get-ChildItem $extensionsPath -recurse -filter "*.psm1" | Select -ExpandProperty FullName | % { Write-Debug "Importing `'$_`'"; Import-Module $_; }
}

#main entry point
#Remove-LastInstallLog

New-Alias -Name ccygwin -Value Chocolatey-Cygwin
New-Alias -Name cgem -Value Chocolatey-RubyGem
New-Alias -Name cinst -Value Chocolatey-Install
New-Alias -Name cinstm -Value Chocolatey-InstallIfMissing
New-Alias -Name clist -Value Chocolatey-List
New-Alias -Name cpack -Value Chocolatey-Pack
New-Alias -Name cpush -Value Chocolatey-Push
New-Alias -Name cpython -Value Chocolatey-Python
New-Alias -Name cuninst -Value Chocolatey-Uninstall
New-Alias -Name cup -Value Chocolatey-Update
New-Alias -Name cver -Value Chocolatey-Version
New-Alias -Name cwebpi -Value Chocolatey-WebPI
New-Alias -Name cwindowsfeatures -Value Chocolatey-WindowsFeatures

Export-ModuleMember -Function @(
	"Chocolatey-Install",
	"Chocolatey-InstallIfMissing",
	"Chocolatey-Update",
	"Chocolatey-Uninstall",
	"Chocolatey-List",
	"Chocolatey-Version",
	"Chocolatey-WebPI",
	"Chocolatey-WindowsFeatures",
	"Chocolatey-Cygwin",
	"Chocolatey-Python",
	"Chocolatey-RubyGem",
	"Chocolatey-Pack",
	"Chocolatey-Push",
	"Chocolatey-Help",
	"Chocolatey-Sources"
) -Alias @(
	"ccygwin",
	"cgem",
	"cinst",
	"cinstm",
	"clist",
	"cpack",
	"cpush",
	"cpython",
	"cuninst",
	"cup",
	"cver",
	"cwebpi",
	"cwindowsfeatures"
)

<#
switch -wildcard ($command) 
{
  "install" { Chocolatey-Install $packageName $source $version $installArguments; }
  "installmissing" { Chocolatey-InstallIfMissing $packageName $source $version; }
  "update" { Chocolatey-Update $packageName $source; }
  "uninstall" {Chocolatey-Uninstall $packageName $version $installArguments; }
  "search" { Chocolatey-List $packageName $source; }
  "list" { Chocolatey-List $packageName $source; }
  "version" { Chocolatey-Version $packageName $source; }
  "webpi" { Chocolatey-WebPI $packageName $installArguments; }
  "windowsfeatures" { Chocolatey-WindowsFeatures $packageName; }
  "cygwin" { Chocolatey-Cygwin $packageName $installArguments; }
  "python" { Chocolatey-Python $packageName $version $installArguments; }
  "gem" { Chocolatey-RubyGem $packageName $version $installArguments; }
  "pack" { Chocolatey-Pack $packageName; }
  "push" { Chocolatey-Push $packageName $source; }
  "help" { Chocolatey-Help; }
  "sources" { Chocolatey-Sources $packageName $name $source; }
  default { Write-Host 'Please run chocolatey /? or chocolatey help'; }
}
#>