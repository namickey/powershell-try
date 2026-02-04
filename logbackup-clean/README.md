
```
powershell -Command "(Get-Item 'logbackup-clean\iis_httperr\a.log').LastWriteTime = (Get-Date).AddYears(-1)"
powershell -Command "Get-Item 'logbackup-clean\iis_httperr\a.log' | Select-Object LastWriteTime"

powershell -Command "(Get-Item 'logbackup-clean\a179.log').LastWriteTime = (Get-Date).AddDays(-179)"
powershell -Command "(Get-Item 'logbackup-clean\a180.log').LastWriteTime = (Get-Date).AddDays(-180)"
powershell -Command "(Get-Item 'logbackup-clean\a181.log').LastWriteTime = (Get-Date).AddDays(-181)"
```

179日前　「forfiles /D -180」の削除対象外
180日前　「forfiles /D -180」の削除対象
181日前　「forfiles /D -180」の削除対象
