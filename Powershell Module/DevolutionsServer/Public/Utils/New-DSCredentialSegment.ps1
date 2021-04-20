function New-DSCredentialSegment {
    <#
    .SYNOPSIS
        Returns the a SensitiveData object which is needed to handle safe transfer of credentials
    #>
    [CmdletBinding()]
    param(
        [string]$Username,
        [string]$Password,
        [string]$UserDomain,
        [string]$MnemonicPassword,
        [bool]$PromptForPassword
    )

    PROCESS {
        $escapedPassword = EscapeForJSon $Password
        
        $SensitiveData = @{
            allowClipboard         = $false
            credentialConnectionId = ""
            pamCredentialId        = ""
            pamCredentialName      = ""
            credentialMode         = 0
            userName               = $Username
            mnemonicPassword       = $MnemonicPassword
            promptForPassword      = $PromptForPassword
            domain                 = $UserDomain
            passwordItem           = @{
                hasSensitiveData = -not [string]::IsNullOrEmpty($escapedPassword)
                sensitiveData    = $escapedPassword
            }
            credentials            = @{
                domain   = $UserDomain
                password = $escapedPassword
                username = $Username
                status   = 0
            }
        }
    
        return $SensitiveData
    }
}