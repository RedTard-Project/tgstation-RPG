@echo off
pushd "%~dp0\..\.." || exit /b 1
call tools\bootstrap\javascript.bat modular_redtard\build\build_modular.ts %*
set "exitCode=%errorlevel%"
popd
exit /b %exitCode%
