
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excelfile = (Get-ChildItem ".\a.xlsx").FullName
$book = $excel.Workbooks.Open($excelfile)
$sheet = $book.WorkSheets.Item('a')

#フィルタをかける
$sheet.Range("E2:F2").AutoFilter(2, "=")

#セルを選択する
$sheet.Activate()
$sheet.Cells.Item(2, 1).Select()


$book.Save()
$book.Close()
$excel.Quit()
