$outfile = New-Object System.IO.StreamWriter("out.csv", $false, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
$outfile.WriteLine("�e�[�u����,�J������,����,�O�̒l,��̒l,�G���[���b�Z�[�W")
$outfile.Close()

(Get-Content ".\chukan.csv" -ErrorAction Stop) | Sort-Object -Unique | Out-File -FilePath ".\out.csv" -Append -Encoding default
