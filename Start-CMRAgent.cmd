@echo off
title CMR Agent Installer

echo Creating CMR Agent folder...
mkdir "%USERPROFILE%\CMR\Agent" >nul 2>&1

echo Installing automation agent...
copy "%~dp0cmr-agent.ps1" "%USERPROFILE%\CMR\Agent\cmr-agent.ps1" /Y >nul

echo Starting automation agent...
powershell.exe -ExecutionPolicy Bypass -WindowStyle Hidden -File "%USERPROFILE%\CMR\Agent\cmr-agent.ps1"

echo.
echo CMR Automation Agent is now running.
echo You may close this window.
timeout /t 2 >nul
exit
