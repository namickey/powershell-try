function Delete-ExcelSheet {
    param(
        $filePath,
        $excel
    )
    $book = $excel.Workbooks.Open($filePath)
 
    # シートの削除
    $excel.worksheets.item("表紙").delete()
     
    # 上書き保存
    $book.Save()
    $book.Close()
}


try {
    # Excelオブジェクト作成
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $false
    $excel.DisplayAlerts = $false
 
    Set-Location 1_renamed
    $list = Get-ChildItem -File -Filter *.xlsx
    ForEach($l in $list) {
        write-host $l.FullName
        Delete-ExcelSheet -filePath $l.FullName -excel $excel
    }
} catch {
    Write-Error "エラーが発生しました: $_"
} finally {
    $excel.Quit()
    $excel = $null
    [GC]::Collect()
}