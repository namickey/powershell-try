@echo off

echo %time%

powershell -executionpolicy Bypass -File diff.ps1

powershell -executionpolicy Bypass -File merge.ps1

echo %time%