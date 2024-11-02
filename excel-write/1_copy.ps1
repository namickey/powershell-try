# �t�@�C���ꗗ�ɋL�ڂ���Ă���t�@�C�����ɕϊ����鏈��

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excelfile = (Get-ChildItem ".\�t�@�C���ꗗ.xlsx").FullName
$book = $excel.Workbooks.Open($excelfile, 0, $true)
$sheet = $book.WorkSheets.Item('�ꗗ')

$flist = @()
$line = 2 #�J�n�s
while($true){
    $f = @{�t�@�C����=""; �t�@�C��ID=""; �e�[�u����=""}
    $ff = New-Object PSObject -Property $f

    # �ŏI�s�̔���
    $filename = $sheet.Cells.Item($line, 2).Text
    if ($filename -eq "") {
        break
    }

    $ff.�t�@�C���� = $filename
    $ff.�t�@�C��ID = $sheet.Cells.Item($line, 3).Text
    $ff.�e�[�u���� = $sheet.Cells.Item($line, 4).Text

    $flist += $ff
    $line += 1
}
$excel.Quit()
$excel = $null
[System.GC]::Collect()

Set-Location 0_input
$list = Get-ChildItem -File -Filter *.xlsx
#$list | ForEach-Object { Write-Output $_.FullName }
Set-Location ../

ForEach($l in $list) {
    $name = $l.Name
    $fullname = $l.FullName

    ForEach($fl in $flist) {
        $tablename = $fl.�e�[�u����+'.xlsx'
        if ($name -eq $tablename) {
            $destination = "1_renamed\" + $fl.�t�@�C���� + ".xlsx"
            Copy-Item $fullname -Destination $destination
            break
        }
    }
}
