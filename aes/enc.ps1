$plain = [System.Text.Encoding]::UTF8.GetBytes("abcde")
$AES = [System.Security.Cryptography.Aes]::Create()
$encrypted = $AES.CreateEncryptor().TransformFinalBlock($plain, 0, $plain.Length)

[System.Convert]::ToBase64String($encrypted) > enc.txt
[System.Convert]::ToBase64String($AES.Key) > share.key
[System.Convert]::ToBase64String($AES.IV) > share.iv

# echo $AES.Key.Length
# echo ([System.Convert]::ToBase64String($AES.Key))
# echo $AES.IV.Length
# echo ([System.Convert]::ToBase64String($AES.IV))
# echo $AES.BlockSize
# echo $AES.Mode
# echo $AES.Padding

# 32
# ju2N5MG1Po+Y2+8LPQaoZ67hW+eWDcp+NzTPKpUBnNY=
# 16
# EfnLHYlHkxG6zF+XMGCCOA==
# 128
# CBC
# PKCS7
