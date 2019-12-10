@echo off
set file=%1
set tool=%~dp0\csigntool.exe
set file=%file:/=\%

echo %file%
echo %tool% sign /r SDK /f "%file%" 
%tool% sign /r SDK /f "%file%" 