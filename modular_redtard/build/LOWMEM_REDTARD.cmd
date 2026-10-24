@echo off
call "%~dp0build.cmd" lowmem %*
echo.
if errorlevel 1 (
    echo modular_redtard low-memory launch FAILED. Scroll up for the errors.
) else (
    echo modular_redtard low-memory server stopped.
)
pause
