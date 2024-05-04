try {
    # AES暗号化オブジェクトを作成
    $AES = [System.Security.Cryptography.Aes]::Create()

    # キーとIVをファイルから読み込む
    $AES.Key = [System.Convert]::FromBase64String((Get-Content ".\encrypt\share.key"))
    $AES.IV = [System.Convert]::FromBase64String((Get-Content ".\encrypt\share.iv"))
    
    # 環境変数から暗号化された文字列を取得
    $encrypted = [System.Convert]::FromBase64String(($Env:enc_text))
    #$encrypted = [System.Convert]::FromBase64String(("EOa/Zh7mlFrTvEAvikSyGg=="))
    
    # 復号化
    $decrypted = $AES.CreateDecryptor().TransformFinalBlock($encrypted, 0, $encrypted.Length)
    return ([System.Text.Encoding]::UTF8.GetString($decrypted))
} catch {
    return 1
}
