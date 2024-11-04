function Copy-ExcelSheet {
    param (
        [string]$filePath,
        $templateSheet,
        $excel
    )

    write-host $filePath
    $workbook = $excel.Workbooks.Open($filePath)
    
    try {
        $templateSheet.Copy([ref]$workbook.Sheets.Item(1))
        $workbook.Save()
    } catch {
        Write-Error "エラーが発生しました: $_"
    } finally {
        $workbook.Close()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
        Remove-Variable -Name workbook
    }
}

Set-Location 1_renamed
$list = Get-ChildItem -File -Filter *.xlsx
$list | ForEach-Object { Write-Output $_.FullName }
Set-Location ../

Write-host (Get-Location)

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$templatefile = (Get-ChildItem ".\template.xlsx").FullName
$templateWorkbook = $excel.Workbooks.Open($templatefile, 0, $true)
$templateSheet = $templateWorkbook.Sheets.Item("表紙")

try {
    ForEach($l in $list) {
        Copy-ExcelSheet -filePath $l.FullName -templateSheet $templateSheet -excel $excel
    }
} catch {
    Write-Error "エラーが発生しました: $_"
} finally {
    $templateWorkbook.Close($false)
    $excel.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($templateSheet) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($templateWorkbook) | Out-Null
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel) | Out-Null
    [GC]::Collect()
    [GC]::WaitForPendingFinalizers()    
}
