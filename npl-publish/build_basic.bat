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
timeout /t 20 /nobreak > nul
cd %curdir%\..\ezlib\
%curdir%\tools\premake5.exe vs2017 --protobuf=..\dependence
@echo on
@echo "build ezlib ..."
@cd %curdir%\..\ezlib\prj
msbuild library/npl-common.vcxproj  	/p:Configuration=%configuration% /p:Platform="%platformname%" /t:%buildtype%
IF %ERRORLEVEL% NEQ 0 goto throwerr

msbuild library/npl-net.vcxproj  		/p:Configuration=%configuration% /p:Platform="%platformname%" /t:%buildtype%
IF %ERRORLEVEL% NEQ 0 goto throwerr

msbuild library/npl-net_module.vcxproj  /p:Configuration=%configuration% /p:Platform="%platformname%" /t:%buildtype%
IF %ERRORLEVEL% NEQ 0 goto throwerr

msbuild library/npl-database.vcxproj  	/p:Configuration=%configuration% /p:Platform="%platformname%" /t:%buildtype%
IF %ERRORLEVEL% NEQ 0 goto throwerr

@echo off
cd %curdir%

exit 0
:throwerr
echo %ERRORLEVEL% 
exit 1
