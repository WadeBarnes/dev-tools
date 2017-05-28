# ==========================================================================================
# Inspired by:
# https://chocolatey.org/docs/development-environment-setup
# https://gist.github.com/ferventcoder/3825023
#
# A PowerShell script that installs the Chocolatey package manager and then uses Chocolatey
# to setup a development environment using a set of Chocolatey config packages.
#
# USAGE:  
# ./up <config/>
# * Where; <config/> is the name of the configuration file to use for setting
#   up the environment.  Defaults to developmentEnv
#
# TODO:
# - Setup a global cache folder and give permissions to all users.  To support installs
#	like slack.
# ==========================================================================================

param (
  [Parameter(Mandatory=$false)][string]$config = 'developmentEnv'
)

$scriptDir = $(Split-Path -parent $MyInvocation.MyCommand.Definition)

function Is-Chocolatey-Installed {
  $ChocoInstallPath = "$($env:SystemDrive)\ProgramData\Chocolatey\bin"
  $ChocoExecutable  = "choco.exe"
  $ChocolateyExecutable  = "chocolatey.exe"

  if ( Test-Path $ChocoInstallPath ) {
    if ( (Test-Path $ChocoInstallPath\$ChocoExecutable) -or (Test-Path $ChocoInstallPath\$ChocolateyExecutable) ) {
	  Write-Host "Chocolatey is already installed ..."
	  return $true
	}
	else {
      Write-Host "Did not find $ChocoExecutable or $ChocolateyExecutable; assuming Chocolatey is not installed ..."
	  return $false
	}
  }
  else {
    Write-Host "Did not find $ChocoInstallPath; assuming Chocolatey is not installed ..."
	return $false
  }
}

function Install-NeededFor {
param(
   [string] $packageName = ''
  ,[bool] $defaultAnswer = $true
)
  if ($packageName -eq '') {return $false}

  $yes = '6'
  $no = '7'
  $msgBoxTimeout='-1'
  $defaultAnswerDisplay = 'Yes'
  $buttonType = 0x4;
  if (!$defaultAnswer) { $defaultAnswerDisplay = 'No'; $buttonType= 0x104;}

  $answer = $msgBoxTimeout
  try {
    $timeout = 10
    $question = "Do you need to install $($packageName)? Defaults to `'$defaultAnswerDisplay`' after $timeout seconds"
    $msgBox = New-Object -ComObject WScript.Shell
    $answer = $msgBox.Popup($question, $timeout, "Install $packageName", $buttonType)
  }
  catch {
  }

  if ($answer -eq $yes -or ($answer -eq $msgBoxTimeout -and $defaultAnswer -eq $true)) {
    write-host "Installing $packageName"
    return $true
  }

  write-host "Not installing $packageName"
  return $false
}

# Install Chocolatey
if( !(Is-Chocolatey-Installed) ) {
  if ( Install-NeededFor 'chocolatey' ) {
    iex ((new-object net.webclient).DownloadString("http://chocolatey.org/install.ps1")) 
  }
}

if ( Test-Path .\config\$config.config ) {
  Write-Host ""
  Write-Host "Using .\config\$config.config ..."
  Write-Host ""
  cinst .\config\$config.config

  Write-Host ""
  Write-Host "If you have made it here without errors, you should be setup and ready to hack on the apps."
  Write-Host ""
  Write-Warning "If you see any failures happen, you may want to reboot and continue to let installers catch up. This script is idempotent and will only apply changes that have not yet been applied."
  Write-Host ""
}
else {
  Write-Host ""
  Write-Warning "Unable to find the specified config file [$config]; .\config\$config.config!"
  Write-Host ""  
}