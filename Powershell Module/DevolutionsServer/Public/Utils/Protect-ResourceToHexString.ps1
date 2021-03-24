function Protect-ResourceToHexString {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .EXAMPLE
    .LINK
    #>
    [CmdletBinding()]
    param(	
        [ValidateNotNullOrEmpty()]
        [string]$unencryptedString
    )

    BEGIN{
        if ([string]::IsNullOrWhiteSpace($Script:DSSessionKey))
        {
            throw "Session Key is missing, you must call Get-ServerInfo before using this method"
        }
    }
    
    PROCESS{    
        $bytes = Encrypt-String $Script:DSSessionKey $unencryptedString
        return Convert-BytesToHex $bytes
    }
}
