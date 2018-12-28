@echo off

SET DISPLAY_USAGE=0
SET DIR=%~dp0%

SET VERSION=v0.5.0
SET DEFAULT_CHOCO_CONFIG=developmentEnv
SET URL=https://raw.githubusercontent.com/WadeBarnes/dev-tools/%VERSION%/chocolatey/

SET SOURCE_BATCH=up.cmd
SET DEST_BATCH=up_%VERSION%.cmd
SET SOURCE_PS=up.ps1
SET DEST_PS=up_%VERSION%.ps1

if "%~1"=="-h" SET DISPLAY_USAGE=1
if "%~1"=="/?" SET DISPLAY_USAGE=1
if "%~1"=="/h" SET DISPLAY_USAGE=1

if "%DISPLAY_USAGE%"=="1" (
  call :usage %0
  exit /B 0
) else (
  call :main %*
  exit /B 0
)

:usage
echo ==============================================================================
echo A wrapper to launch the main Chocolatey setup scripts from 
echo https://github.com/WadeBarnes/dev-tools/tree/master/chocolatey.
echo.
echo The scripts are downloaded from a specific release (refer to the script below)
echo and launched using the default or supplied configuration settings.
echo.
echo This script can be added to your project and the defaults modified to use
echo your custom configuration by default.
echo.
echo USAGE:
echo %1 ^<config/^>
echo * Where; ^<config/^> is the name of the configuration file to use for setting
echo   up the environment.  Defaults to the setting defined by DEFAULT_CHOCO_CONFIG.
echo   The scripts expect the configuration file to use the following location and
echo   naming conventions;
echo     * .\config\^<config/^>.config
echo   Configuration files are expected to be in Chocolatey package file format.
echo   Refer to the examples for details;
echo     * https://github.com/WadeBarnes/dev-tools/tree/master/chocolatey/config
echo.
echo ==============================================================================
exit /B 0

:main
if exist %DIR%%DEST_BATCH% (
  echo.
  echo %DIR%%DEST_BATCH% already exists, skipping download ...
) else (
  echo.
  echo Downloading %URL%%SOURCE_BATCH% to %DIR%%DEST_BATCH% ...
  @PowerShell -Command "Invoke-WebRequest %URL%%SOURCE_BATCH% -OutFile %DIR%%DEST_BATCH%"
)

if exist %DIR%%DEST_PS% (
  echo.
  echo %DIR%%DEST_PS% already exists, skipping download ...
) else (
  echo.
  echo Downloading %URL%%SOURCE_PS% to %DIR%%DEST_PS% ...
  @PowerShell -Command "Invoke-WebRequest %URL%%SOURCE_PS% -OutFile %DIR%%DEST_PS%"
)

if "%~1"=="" (
  echo.
  echo Launching %DIR%%DEST_BATCH% with default configuration; %DEFAULT_CHOCO_CONFIG% ...
  call %DIR%%DEST_BATCH% %DEFAULT_CHOCO_CONFIG%
) else (
  echo.
  echo Launching %DIR%%DEST_BATCH%, with supplied configuration; %* ...
  call %DIR%%DEST_BATCH% %*
)
exit /B 0