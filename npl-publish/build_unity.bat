@echo off
set curdir=%~dp0
cd %curdir%

if not "%1" == "" (
	set unity="%1"
) else (
	if EXIST "d:\Program Files\Unity\Editor\Unity.exe" (
		set unity="d:\Program Files\Unity\Editor\Unity.exe"
	) else (
		if EXIST "C:\Program Files\Unity\Editor\Unity.exe" set unity="C:\Program Files\Unity\Editor\Unity.exe"
	)
)

echo build unity demo...
%unity% -batchmode -quit -nographics -executeMethod BatchBuild.BuildX64  -logFile .\UnityEditor.log -projectPath "..\npl-sdk-prj\npl-sdk-csharp" 
echo done!