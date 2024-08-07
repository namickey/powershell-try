# 入力ファイル２つ、出力ファイル１つをセットアップ
$before = import-csv -Encoding OEM -Path .\before.csv
$after = import-csv -Encoding OEM -Path .\after.csv
$outfile = New-Object System.IO.StreamWriter("chukan.csv", $false, [System.Text.Encoding]::GetEncoding("sjis"))

# チェック処理
# $bf: 比較対象1
# $af: 比較対象2
function checkAll($bf, $af) {
    checkSize $bf $af
    #checkXXXXXX
    #checkXXXXXX
}

# サイズチェック
# 一致確認
function checkSize($bf, $af) {
    if ($bf.サイズ -ne $af.サイズ) {
        $message = "$($bf.テーブル名),$($bf.カラム名),サイズ,$($bf.サイズ),$($af.サイズ),`"size is different.`""
        #Write-Host $message
        $outfile.WriteLine($message)
    }
}

# after.csvでループする。※before.csvにだけ存在するテーブルやカラムは見つからない
$i = 0
foreach ($af in $after) {
    $bf = $before | where-object { $_.テーブルID -eq $af.テーブルID}
    if ($null -eq $bf) {
        # テーブルが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($af.テーブルID),,,,,`"テーブル is not found in before.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $bf = $bf | where-object { $_.カラム名 -eq $af.カラム名 }
    if ($null -eq $bf) {
        # カラムが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($af.テーブル名),$($af.カラム名),,,,`"カラム is not found in before.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # 同じキー（テーブルとカラム）が見つかった場合、チェック処理を行う
    checkAll $bf $af
    if ($i % 2 -eq 0) {
        Write-Host $i
    }
    $i = $i + 1
}

# before.csvでループする。※after.csvにだけ存在するテーブルやカラムは見つからない
$i = 0
foreach ($bf in $before) {
    $af = $after | where-object { $_.テーブルID -eq $bf.テーブルID}
    if ($null -eq $af) {
        # テーブルが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($bf.テーブルID),,,,,`"テーブル is not found in after.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $af = $af | where-object { $_.カラム名 -eq $bf.カラム名 }
    if ($null -eq $af) {
        # カラムが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($bf.テーブルID),$($bf.カラム名),,,,`"カラム is not found in after.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # 同じキー（テーブルとカラム）が見つかった場合、チェック処理を行う
    checkAll $bf $af
    if ($i % 2 -eq 0) {
        Write-Host $i
    }
    $i = $i + 1
}

$outfile.Close()
