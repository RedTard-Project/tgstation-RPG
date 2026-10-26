@echo off
call "%~dp0build.cmd" build %*
echo.
if errorlevel 1 (
    echo modular_redtard build FAILED. Scroll up for the errors.
) else (
    echo modular_redtard build finished.
)
pause
