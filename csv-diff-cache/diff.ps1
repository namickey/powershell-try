# ���̓t�@�C���Q�A�o�̓t�@�C���P���Z�b�g�A�b�v
$before = import-csv -Encoding OEM -Path .\before-large.csv
$after = import-csv -Encoding OEM -Path .\after-large.csv
$outfile = New-Object System.IO.StreamWriter("chukan.csv", $false, [System.Text.Encoding]::GetEncoding("sjis"))

# �`�F�b�N����
# $bf: ��r�Ώ�1
# $af: ��r�Ώ�2
function checkAll($bf, $af) {
    checkSize $bf $af
    #checkXXXXXX
    #checkXXXXXX
}

# �T�C�Y�`�F�b�N
# ��v�m�F
function checkSize($bf, $af) {
    if ($bf.�T�C�Y -ne $af.�T�C�Y) {
        $message = "$($bf.�e�[�u����),$($bf.�J������),�T�C�Y,$($bf.�T�C�Y),$($af.�T�C�Y),`"size is different.`""
        Write-Host $message
        $outfile.WriteLine($message)
    }
}



$time1 = Get-Date # �������Ԍv���p
$i = 0            # ���[�v�J�E���^
$table_cache_bf = $null       # �e�[�u���L���b�V��
$table_cache_table_id = $null # �e�[�u��ID�L���b�V��
# after.csv�Ń��[�v����B��before.csv�ɂ������݂���e�[�u����J�����͌�����Ȃ�
foreach ($af in $after) {
    # �e�[�u���i�荞�ݏ������x�����߁A�L���b�V�������s��
    # �e�[�u��ID���ς������A�e�[�u���i�荞�݂��s���A�e�[�u���L���b�V�����X�V
    if ($af.�e�[�u��ID -ne $table_cache_table_id) {
        $table_cache_bf = $before | where-object { $_.�e�[�u��ID -eq $af.�e�[�u��ID}
        $table_cache_table_id = $af.�e�[�u��ID
    }
    
    if ($null -eq $table_cache_bf) {
        # �e�[�u����������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($af.�e�[�u��ID),,,,,`"�e�[�u�� is not found in before.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $bf = $table_cache_bf | where-object { $_.�J������ -eq $af.�J������ }
    if ($null -eq $bf) {
        # �J������������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($af.�e�[�u����),$($af.�J������),,,,`"�J���� is not found in before.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # �����L�[�i�e�[�u���ƃJ�����j�����������ꍇ�A�`�F�b�N�������s��
    checkAll $bf $af
    if ($i % 1000 -eq 0) {
        $time2 = Get-Date
        Write-Host $i " : " ($time2 - $time1).TotalSeconds
        $time1 = $time2
    }
    $i = $i + 1
}


$time1 = Get-Date # �������Ԍv���p
$i = 0            # ���[�v�J�E���^
$table_cache_af = $null       # �e�[�u���L���b�V��
$table_cache_table_id = $null # �e�[�u��ID�L���b�V��
# before.csv�Ń��[�v����B��after.csv�ɂ������݂���e�[�u����J�����͌�����Ȃ�
foreach ($bf in $before) {
    # �e�[�u���i�荞�ݏ������x�����߁A�L���b�V�������s��
    # �e�[�u��ID���ς������A�e�[�u���i�荞�݂��s���A�e�[�u���L���b�V�����X�V
    if ($bf.�e�[�u��ID -ne $table_cache_table_id) {
        $table_cache_af = $after | where-object { $_.�e�[�u��ID -eq $bf.�e�[�u��ID}
        $table_cache_table_id = $bf.�e�[�u��ID
    }

    if ($null -eq $table_cache_af) {
        # �e�[�u����������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($bf.�e�[�u��ID),,,,,`"�e�[�u�� is not found in after.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $af = $table_cache_af | where-object { $_.�J������ -eq $bf.�J������ }
    if ($null -eq $af) {
        # �J������������Ȃ��ꍇ�A�G���[���b�Z�[�W���o�͂��Ď���
        $message = "$($bf.�e�[�u��ID),$($bf.�J������),,,,`"�J���� is not found in after.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # �����L�[�i�e�[�u���ƃJ�����j�����������ꍇ�A�`�F�b�N�������s��
    checkAll $bf $af
    if ($i % 1000 -eq 0) {
        $time2 = Get-Date
        Write-Host $i " : " ($time2 - $time1).TotalSeconds
        $time1 = $time2
    }
    $i = $i + 1
}

$outfile.Close()
