@echo off

FOR /F "usebackq" %%i IN (`powershell -executionpolicy Bypass -File dec.ps1`) DO set value=%%i

echo %value%
