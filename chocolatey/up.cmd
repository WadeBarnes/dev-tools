@echo off
REM ==============================================================================
REM Inspired by:
REM https://chocolatey.org/docs/development-environment-setup
REM https://gist.github.com/ferventcoder/1107920
REM
REM Wrapper to launch the main PowerShell script.  Use this script when installing
REM chocolatey for the first time.
REM
REM USAGE:  
REM up.cmd <config/>
REM * Where; <config/> is the name of the configuration file to use for setting
REM   up the environment.  Defaults to developmentEnv
REM
REM ==============================================================================

SET DIR=%~dp0%
echo.
echo Launching the PowerShell script; %DIR%up.ps1 ...
echo.
@PowerShell -NoProfile -ExecutionPolicy unrestricted -Command "& '%DIR%up.ps1' %*"
pause