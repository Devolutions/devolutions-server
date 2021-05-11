function Decrypt-String($key, $encryptedStringWithIV) {
<#
.SYNOPSIS
Legacy - Do not use
.DESCRIPTION

.EXAMPLE

.LINK
#>
    $bytes = Convert-HextoBytes $encryptedStringWithIV
    $IV = $bytes[0..15]
    $aesManaged = New-AESService $key $IV
    $decryptor = $aesManaged.CreateDecryptor();
    $unencryptedData = $decryptor.TransformFinalBlock($bytes, 16, $bytes.Length - 16);
    $aesManaged.Dispose()
    [System.Text.Encoding]::UTF8.GetString($unencryptedData).Trim([char]0)
}