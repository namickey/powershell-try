# 出力CSVへ、CSVヘッダーの書き込み
$outfile = New-Object System.IO.StreamWriter("out.csv", $false, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
$outfile.WriteLine("テーブル名,カラム名,項目,前の値,後の値,エラーメッセージ")
$outfile.Close()

# 中間CSVをソートして、重複排除して、出力CSVに書き込み
(Get-Content ".\chukan.csv" -ErrorAction Stop) | Sort-Object -Unique | Out-File -FilePath ".\out.csv" -Append -Encoding default
