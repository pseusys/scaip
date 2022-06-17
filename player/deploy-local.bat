@echo off
:: Path to Supreme Commander mods directory
set mod_loc=C:\ProgramData\FAForever\user\My Games\Gas Powered Games\Supreme Commander Forged Alliance\mods\scaip

:: Clear mod directory if already exists
if exist "%mod_loc%" rmdir "%mod_loc%" /s/q
mkdir "%mod_loc%"

:: Copy .lua mod files
xcopy /y/q/s/e/i "%~dp0hook" "%mod_loc%\hook"
xcopy /y/q/s/e/i "%~dp0lua" "%mod_loc%\lua"

:: Copy config files
copy /y "%~dp0SCAIP.jpg" "%mod_loc%\SCAIP.jpg"
copy /y "%~dp0mod_info.lua" "%mod_loc%\mod_info.lua"
