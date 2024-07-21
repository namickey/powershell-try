
# �`�F�b�N����
# $t1: ��r�Ώ�1
# $t2: ��r�Ώ�2
# $outfile: �o�̓t�@�C��
function check($t1, $t2, $outfile) {
    if ($t1.�T�C�Y -ne $t2.�T�C�Y) {
        $message = "$($t1.�e�[�u����),$($t1.�J������),�T�C�Y,$($t1.�T�C�Y),$($t2.�T�C�Y),`"size is different.`""
        Write-Host $message
        $outfile.WriteLine($message)
    }
}

# ���̓t�@�C���Q�A�o�̓t�@�C���P���Z�b�g�A�b�v
$before = import-csv -Encoding OEM -Path .\before.csv
$after = import-csv -Encoding OEM -Path .\after.csv
$outfile = New-Object System.IO.StreamWriter("chukan.csv", $false, [System.Text.Encoding]::GetEncoding("sjis"))

# after.csv�Ń��[�v����B��before.csv�ɂ������݂���e�[�u����J�����͌�����Ȃ�
foreach ($af in $after) {
    $bf = $before | where-object { $_.�e�[�u���� -eq $af.�e�[�u����}
    if ($null -eq $bf) {
        # �e�[�u����������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($af.�e�[�u����),,,,,`"�e�[�u�� is not found in before.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $bf = $before | where-object { $_.�e�[�u���� -eq $af.�e�[�u���� -and $_.�J������ -eq $af.�J������ }
    if ($null -eq $bf) {
        # �J������������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($af.�e�[�u����),$($af.�J������),,,,`"�J���� is not found in before.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # �����L�[�i�e�[�u���ƃJ�����j�����������ꍇ�A�`�F�b�N�������s��
    check $af $bf $outfile
    
}

# before.csv�Ń��[�v����B��after.csv�ɂ������݂���e�[�u����J�����͌�����Ȃ�
foreach ($bf in $before) {
    $af = $after | where-object { $_.�e�[�u���� -eq $bf.�e�[�u����}
    if ($null -eq $af) {
        # �e�[�u����������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($bf.�e�[�u����),,,,,`"�e�[�u�� is not found in after.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $af = $after | where-object { $_.�e�[�u���� -eq $bf.�e�[�u���� -and $_.�J������ -eq $bf.�J������ }
    if ($null -eq $af) {
        # �J������������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($bf.�e�[�u����),$($bf.�J������),,,,`"�J���� is not found in after.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # �����L�[�i�e�[�u���ƃJ�����j�����������ꍇ�A�`�F�b�N�������s��
    check $af $bf $outfile
}

$outfile.Close()
