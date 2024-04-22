$AES = [System.Security.Cryptography.Aes]::Create()

$AES.Key = [System.Convert]::FromBase64String((Get-Content "share.key"))
$AES.IV = [System.Convert]::FromBase64String((Get-Content "share.iv"))
$encrypted = [System.Convert]::FromBase64String((Get-Content "enc.txt"))

$decrypted = $AES.CreateDecryptor().TransformFinalBlock($encrypted, 0, $encrypted.Length)
return ([System.Text.Encoding]::UTF8.GetString($decrypted))