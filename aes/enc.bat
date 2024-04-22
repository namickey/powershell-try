@echo off

FOR /F "usebackq" %%i IN (`powershell -executionpolicy Bypass -File enc.ps1`) DO set value=%%i

echo %value%
