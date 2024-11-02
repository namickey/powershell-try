# ファイルコピーを行うスクリプト
# また、ファイル一覧に記載されているファイル名に変換を行う

$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$excelfile = (Get-ChildItem ".\ファイル一覧.xlsx").FullName
$book = $excel.Workbooks.Open($excelfile, 0, $true)
$sheet = $book.WorkSheets.Item('一覧')

$flist = @()
$line = 2 #開始行
while($true){
    $f = @{ファイル名=""; ファイルID=""; テーブル名=""}
    $ff = New-Object PSObject -Property $f

    # 最終行の判定
    $filename = $sheet.Cells.Item($line, 2).Text
    if ($filename -eq "") {
        break
    }

    $ff.ファイル名 = $filename
    $ff.ファイルID = $sheet.Cells.Item($line, 3).Text
    $ff.テーブル名 = $sheet.Cells.Item($line, 4).Text

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

$i = 0
ForEach($l in $list) {
    $name = $l.Name
    $fullname = $l.FullName

    ForEach($fl in $flist) {
        $tablename = $fl.テーブル名+'.xlsx'
        if ($name -eq $tablename) {
            $destination = "1_renamed\" + $fl.ファイル名 + ".xlsx"
            Copy-Item $fullname -Destination $destination
            write-host $name.padright(40,' ')",=>, "$destination
            $i++
            break
        }
    }
}
write-host "コピー数: $i"
