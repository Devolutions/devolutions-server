function Encrypt-String($key, $unencryptedString) {
<#
.SYNOPSIS
Legacy - Do not use
.DESCRIPTION

.EXAMPLE

.LINK
#>
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($unencryptedString)
    $aesManaged = New-AESService $key
    $encryptor = $aesManaged.CreateEncryptor()
    $encryptedData = $encryptor.TransformFinalBlock($bytes, 0, $bytes.Length);
    [byte[]] $fullData = $aesManaged.IV + $encryptedData
    $aesManaged.Dispose()
    $fullData
}