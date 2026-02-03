
```
powershell -Command "(Get-Item 'logbackup-clean\iis_httperr\a.log').LastWriteTime = (Get-Date).AddYears(-1)"
powershell -Command "Get-Item 'logbackup-clean\iis_httperr\a.log' | Select-Object LastWriteTime"
```
