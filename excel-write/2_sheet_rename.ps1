# エクセル編集（シート名変更）

function Rename-ExcelSheet {
    param (
        [string]$filePath,
        [string]$currentSheetName,
        [string]$newSheetName,
        $excel
    )

    try {
        $workbook = $excel.Workbooks.Open($filePath)
        
        # シート名変更
        $sheet = $workbook.Sheets.Item($currentSheetName) 
        $sheet.Name = $newSheetName

        # セルの値を変更
        $sheet.Cells.Item(1, 2).Value2 = "2024/01/01"

        $workbook.Save()
    } catch {
        Write-Error "エラーが発生しました: $_"
    } finally {
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet) | Out-Null
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
        Remove-Variable -Name workbook
        Remove-Variable -Name sheet
    }
}

Set-Location 1_renamed
$list = Get-ChildItem -File -Filter *.xlsx
$list | ForEach-Object { Write-Output $_.FullName }

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false

try{
    ForEach($l in $list) {
        Rename-ExcelSheet -filePath $l.FullName -currentSheetName "データ" -newSheetName "テーブル" -excel $excel
    }
} catch {
    Write-Error "エラーが発生しました: $_"
} finally {
    $excel.Quit()
    [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
    Remove-Variable -Name excel
}
