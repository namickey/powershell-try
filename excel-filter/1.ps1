# �t�@�C���R�s�[���s���X�N���v�g
# �܂��A�t�@�C���ꗗ�ɋL�ڂ���Ă���t�@�C�����ɕϊ����s��

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excelfile = (Get-ChildItem ".\a.xlsx").FullName
$book = $excel.Workbooks.Open($excelfile)
$sheet = $book.WorkSheets.Item('a')

#$sheet.AutoFilterMode = $false
#$sheet.cells.item(6,2).AutoFilter()

$sheet.Range("E2:F2").AutoFilter(2, "=")

$book.Save()
$book.Close()
$excel.Quit()
