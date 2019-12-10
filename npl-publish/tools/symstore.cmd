@echo off
:: 添加symbol文件到指定目录
set symbol_path=%1
set symbol_path=%symbol_path:/=\%
set symbol_root=%2
set symbol_info=%3

set version=%4
set tool=%~dp0\symstore.exe

echo %tool% add /s %symbol_root% /compress /r /f %symbol_path% /t NPL /v %version% /c %symbol_info%
%tool% add /s %symbol_root% /compress /r /f %symbol_path% /t NPL /v %version% /c %symbol_info%
