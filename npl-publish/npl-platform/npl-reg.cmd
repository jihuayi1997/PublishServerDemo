@echo off
set ~dp0=%~dp0

if exist "%~dp0%npl-platform.exe" (
	reg add HKLM\SOFTWARE\WOW6432Node\Boltrend\NGL /v 1000 /t REG_DWORD /d "1000" /f
	reg add HKLM\SOFTWARE\WOW6432Node\Boltrend\NGL /v 1001 /t REG_DWORD /d "1000" /f
	reg add HKLM\SOFTWARE\WOW6432Node\Boltrend\NGL_1000 /v MainProc /t REG_SZ /d "%~dp0%npl-platform.exe" /f
) else (
	echo npl-platform is not exist in current path.
)
pause