@echo off
set curdir=%~dp0

cd %curdir%

:: call ..\npl-proto\protoc.bat < nul

:: buildtype [build/rebuild]
set buildtype=%1 

:: platform [Win32/x64]
set platformname=%2
set cmakeparam="Visual Studio 15 2017"
if "%platformname%" == "x64" set cmakeparam="Visual Studio 15 2017 Win64"

:: configuration [Release/Debug]
set configuration=%3

echo buildtype: %buildtype% 
echo platform: %platformname%
echo cmakeparam: %cmakeparam%
echo configuration: %configuration%

cd %curdir%
IF EXIST "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsx86_amd64.bat" (
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\VC\Auxiliary\Build\vcvarsx86_amd64.bat"
) ELSE (
call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsx86_amd64.bat"
)

@echo "build npl-launcher ..."
@if exist %curdir%\..\npl-launcher\build_%platformname% (
    @rmdir /s /q %curdir%\..\npl-launcher\build_%platformname%
)
@mkdir %curdir%\..\npl-launcher\build_%platformname%

@cd %curdir%\..\npl-launcher\build_%platformname%

cmake .. -G %cmakeparam%
msbuild Npl-Launcher.sln /p:Configuration=%configuration% /p:Platform="%platformname%" /t:%buildtype%
IF %ERRORLEVEL% NEQ 0 goto throwerr

@echo off
cd %curdir%

exit 0
:throwerr
echo %ERRORLEVEL% 
exit 1
