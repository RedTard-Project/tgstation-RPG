@echo off
rem The editor of the rogue HUD's layout: see hud_editor.py.
py -3 "%~dp0hud_editor.py" %*
if errorlevel 1 pause
