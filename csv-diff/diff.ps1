
# チェック処理
# $t1: 比較対象1
# $t2: 比較対象2
# $outfile: 出力ファイル
function check($t1, $t2, $outfile) {
    if ($t1.サイズ -ne $t2.サイズ) {
        $message = "$($t1.テーブル名),$($t1.カラム名),サイズ,$($t1.サイズ),$($t2.サイズ),`"size is different.`""
        Write-Host $message
        $outfile.WriteLine($message)
    }
}

# 入力ファイル２つ、出力ファイル１つをセットアップ
$before = import-csv -Encoding OEM -Path .\before.csv
$after = import-csv -Encoding OEM -Path .\after.csv
$outfile = New-Object System.IO.StreamWriter("chukan.csv", $false, [System.Text.Encoding]::GetEncoding("sjis"))

# after.csvでループする。※before.csvにだけ存在するテーブルやカラムは見つからない
foreach ($af in $after) {
    $bf = $before | where-object { $_.テーブル名 -eq $af.テーブル名}
    if ($null -eq $bf) {
        # テーブルが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($af.テーブル名),,,,,`"テーブル is not found in before.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $bf = $before | where-object { $_.テーブル名 -eq $af.テーブル名 -and $_.カラム名 -eq $af.カラム名 }
    if ($null -eq $bf) {
        # カラムが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($af.テーブル名),$($af.カラム名),,,,`"カラム is not found in before.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # 同じキー（テーブルとカラム）が見つかった場合、チェック処理を行う
    check $af $bf $outfile
    
}

# before.csvでループする。※after.csvにだけ存在するテーブルやカラムは見つからない
foreach ($bf in $before) {
    $af = $after | where-object { $_.テーブル名 -eq $bf.テーブル名}
    if ($null -eq $af) {
        # テーブルが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($bf.テーブル名),,,,,`"テーブル is not found in after.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $af = $after | where-object { $_.テーブル名 -eq $bf.テーブル名 -and $_.カラム名 -eq $bf.カラム名 }
    if ($null -eq $af) {
        # カラムが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($bf.テーブル名),$($bf.カラム名),,,,`"カラム is not found in after.csv`""
        Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # 同じキー（テーブルとカラム）が見つかった場合、チェック処理を行う
    check $af $bf $outfile
}

$outfile.Close()
