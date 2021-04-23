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

    BEGIN {
        if (!(Get-Variable DSSessionKey -Scope Global -ErrorAction SilentlyContinue) -or [string]::IsNullOrWhiteSpace($Global:DSSessionKey)) {
            throw "Session Key is missing, you must call Get-ServerInfo before using this method"
        }
    }
    
    PROCESS {    
        $bytes = Encrypt-String $Global:DSSessionKey $unencryptedString
        return Convert-BytesToHex $bytes
    }
}
