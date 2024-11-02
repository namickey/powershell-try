# エクセル編集（シート名変更）

function Rename-ExcelSheet {
    param (
        [string]$filePath,
        [string]$currentSheetName,
        [string]$newSheetName
    )

    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false

    try {
        $workbook = $excel.Workbooks.Open($filePath)
        
        # シート名変更
        $sheet = $workbook.Sheets.Item($currentSheetName) 
        $sheet.Name = $newSheetName

        # セルの値を変更
        $sheet.Cells.Item(2, 2).Value2 = "新規"

        $workbook.Save()
    } catch {
        Write-Error "エラーが発生しました: $_"
    } finally {
        $excel.Quit()

        # COMオブジェクトの解放
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($sheet) | Out-Null
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($workbook) | Out-Null
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
        Remove-Variable -Name excel
        Remove-Variable -Name workbook
        Remove-Variable -Name sheet
    }
}

Set-Location 1_renamed
$list = Get-ChildItem -File -Filter *.xlsx
$list | ForEach-Object { Write-Output $_.FullName }

ForEach($l in $list) {
    Rename-ExcelSheet -filePath $l.FullName -currentSheetName "表紙" -newSheetName "タイトル"
}

