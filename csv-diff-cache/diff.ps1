# 入力ファイル２つ、出力ファイル１つをセットアップ
$before = import-csv -Encoding OEM -Path .\before-large.csv
$after = import-csv -Encoding OEM -Path .\after-large.csv
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
        Write-Host $message
        $outfile.WriteLine($message)
    }
}



$time1 = Get-Date # 処理時間計測用
$i = 0            # ループカウンタ
$table_cache_bf = $null       # テーブルキャッシュ
$table_cache_table_id = $null # テーブルIDキャッシュ
# after.csvでループする。※before.csvにだけ存在するテーブルやカラムは見つからない
foreach ($af in $after) {
    # テーブル絞り込み処理が遅いため、キャッシュ化を行う
    # テーブルIDが変わったら、テーブル絞り込みを行い、テーブルキャッシュを更新
    if ($af.テーブルID -ne $table_cache_table_id) {
        $table_cache_bf = $before | where-object { $_.テーブルID -eq $af.テーブルID}
        $table_cache_table_id = $af.テーブルID
    }
    
    if ($null -eq $table_cache_bf) {
        # テーブルが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($af.テーブルID),,,,,`"テーブル is not found in before.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $bf = $table_cache_bf | where-object { $_.カラム名 -eq $af.カラム名 }
    if ($null -eq $bf) {
        # カラムが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($af.テーブル名),$($af.カラム名),,,,`"カラム is not found in before.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # 同じキー（テーブルとカラム）が見つかった場合、チェック処理を行う
    checkAll $bf $af
    if ($i % 1000 -eq 0) {
        $time2 = Get-Date
        Write-Host $i " : " ($time2 - $time1).TotalSeconds
        $time1 = $time2
    }
    $i = $i + 1
}


$time1 = Get-Date # 処理時間計測用
$i = 0            # ループカウンタ
$table_cache_af = $null       # テーブルキャッシュ
$table_cache_table_id = $null # テーブルIDキャッシュ
# before.csvでループする。※after.csvにだけ存在するテーブルやカラムは見つからない
foreach ($bf in $before) {
    # テーブル絞り込み処理が遅いため、キャッシュ化を行う
    # テーブルIDが変わったら、テーブル絞り込みを行い、テーブルキャッシュを更新
    if ($bf.テーブルID -ne $table_cache_table_id) {
        $table_cache_af = $after | where-object { $_.テーブルID -eq $bf.テーブルID}
        $table_cache_table_id = $bf.テーブルID
    }

    if ($null -eq $table_cache_af) {
        # テーブルが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($bf.テーブルID),,,,,`"テーブル is not found in after.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    $af = $table_cache_af | where-object { $_.カラム名 -eq $bf.カラム名 }
    if ($null -eq $af) {
        # カラムが見つからない場合、エラーメッセージを出力して次へ
        $message = "$($bf.テーブルID),$($bf.カラム名),,,,`"カラム is not found in after.csv`""
        #Write-Host $message
        $outfile.WriteLine($message)
        continue
    }
    # 同じキー（テーブルとカラム）が見つかった場合、チェック処理を行う
    checkAll $bf $af
    if ($i % 1000 -eq 0) {
        $time2 = Get-Date
        Write-Host $i " : " ($time2 - $time1).TotalSeconds
        $time1 = $time2
    }
    $i = $i + 1
}

$outfile.Close()
