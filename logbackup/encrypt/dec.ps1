try {
    # AES�Í����I�u�W�F�N�g���쐬
    $AES = [System.Security.Cryptography.Aes]::Create()

    # �L�[��IV���t�@�C������ǂݍ���
    $AES.Key = [System.Convert]::FromBase64String((Get-Content ".\encrypt\share.key"))
    $AES.IV = [System.Convert]::FromBase64String((Get-Content ".\encrypt\share.iv"))
    
    # ���ϐ�����Í������ꂽ��������擾
    $encrypted = [System.Convert]::FromBase64String(($Env:enc_text))
    
    # ������
    $decrypted = $AES.CreateDecryptor().TransformFinalBlock($encrypted, 0, $encrypted.Length)

    # �����������������Ԃ�
    return ([System.Text.Encoding]::UTF8.GetString($decrypted))
} catch {
    # �\�����ʃG���[�����������ꍇ��1��Ԃ�
    return 1
}
