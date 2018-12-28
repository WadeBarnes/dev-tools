@echo off

SET DISPLAY_USAGE=0
SET DIR=%~dp0%
SET PS_SCRIPT_NAME=%~n0%.ps1

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
echo Inspired by:
echo https://chocolatey.org/docs/development-environment-setup
echo https://gist.github.com/ferventcoder/1107920
echo.
echo Wrapper to launch the main PowerShell script of the same name.
echo Use this script when installing chocolatey for the first time.
echo.
echo Usage:
echo %1 ^<config/^>
echo * Where; ^<config/^> is the name of the configuration file to use for setting
echo   up the environment.  Defaults to developmentEnv
echo.
echo ==============================================================================
exit /B 0

:main
echo.
echo Launching the PowerShell script; %DIR%%PS_SCRIPT_NAME%, with %* ...
echo.
@PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "& '%DIR%%PS_SCRIPT_NAME%' %*"
exit /B 0