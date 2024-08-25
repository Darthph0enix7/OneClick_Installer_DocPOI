@echo off
cd /D "%~dp0"

:: Check if the script is running as administrator
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Requesting administrative privileges...
    powershell start-process '%0' -verb runas
    exit /B
)

:: Function to check and enable a Windows feature
:CheckAndEnableFeature
set featureName=%1
Dism /online /Get-FeatureInfo /FeatureName:%featureName% | findstr /C:"State : Enabled" >nul
if %ERRORLEVEL% EQU 0 (
    echo %featureName% is already enabled.
) else (
    echo Enabling %featureName%...
    Dism /online /Enable-Feature /FeatureName:%featureName% /All
)
exit /B

:: Check and enable Hyper-V
call :CheckAndEnableFeature Hyper-V

:: Check and enable Virtual Machine Platform
call :CheckAndEnableFeature VirtualMachinePlatform

:: Check and enable Windows Subsystem for Linux
call :CheckAndEnableFeature Microsoft-Windows-Subsystem-Linux

echo All required features are enabled.

:: Done
echo Done!
pause
