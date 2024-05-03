@echo off
setlocal enabledelayedexpansion

echo %1
set bb=%1

if defined bb (
    echo %bb% is defined
) else (
    echo %bb% is not defined
)

rem set aa=%1
rem echo %aa%
