@echo off

cd /d %~dp0

FOR /F "usebackq" %%i IN (`powershell -executionpolicy Bypass -File dec.ps1`) DO set value=%%i


echo %date% %time% %value% >> out.txt
