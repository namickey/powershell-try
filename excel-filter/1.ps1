
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excelfile = (Get-ChildItem ".\a.xlsx").FullName
$book = $excel.Workbooks.Open($excelfile)
$sheet = $book.WorkSheets.Item('a')

# E2セルに対してフィルタがかかっているかどうかを判定する
if ($sheet.AutoFilterMode) {
    $filterRange = $sheet.AutoFilter.Range
    $fcell = $filterRange.Address().split(":")[0].replace("$","")
    #$umu = $filterRange[1].value2
    
    if ($fcell -eq "E2") {
        Write-Output "E2セルにフィルタがかかっています。"
        $sheet.Range("E2:G2").AutoFilter(2, "=")
    } else {
        Write-Output "E2セルにフィルタがかかっていません。"
        $sheet.Range("F2:G2").AutoFilter(1, "=")
    }
} else {
    Write-Output "シートにフィルタがかかっていません。"
}

#セルを選択する
$sheet.Activate()
$sheet.Cells.Item(2, 1).Select()


$book.Save()
$book.Close()
$excel.Quit()
