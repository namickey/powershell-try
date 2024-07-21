@echo off

powershell -executionpolicy Bypass -File diff.ps1

powershell -executionpolicy Bypass -File merge.ps1
