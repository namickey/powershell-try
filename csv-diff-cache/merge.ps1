# �o��CSV�ցACSV�w�b�_�[�̏�������
$outfile = New-Object System.IO.StreamWriter("out.csv", $false, [System.Text.Encoding]::GetEncoding("Shift_JIS"))
$outfile.WriteLine("�e�[�u����,�J������,����,�O�̒l,��̒l,�G���[���b�Z�[�W")
$outfile.Close()

# ����CSV���\�[�g���āA�d���r�����āA�o��CSV�ɏ�������
(Get-Content ".\chukan.csv" -ErrorAction Stop) | Sort-Object -Unique | Out-File -FilePath ".\out.csv" -Append -Encoding default
