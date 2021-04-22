function New-DSDataSegment {
    <#
        .SYNOPSIS
        
        .DESCRIPTION

        .NOTES
    #>
    [CmdletBinding()]
    PARAM(
        [hashtable]$ParamList
    )

    PROCESS {
        $ParamList.Add("EscapedPassword", (EscapeForJSon $ParamList.Password))
        
        $data = switch ($ParamList.ConnectionSubType) {
            ([Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::Default) { UsernamePassword $ParamList; break; }
            ([Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::PrivateKey) { PrivateKey $ParamList; break; }
            Default { $null }
        }

        return Protect-ResourceToHexString ($data | ConvertTo-Json)
    }
}

function UsernamePassword {
    PARAM ( $ParamList )
    
    $data = @{
        allowClipboard         = $false
        credentialConnectionId = ""
        pamCredentialId        = ""
        pamCredentialName      = ""
        credentialMode         = 0
        credentials            = $null
        domain                 = $ParamList.Domain
        mnemonicPassword       = $ParamList.MnemonicPassword
        passwordItem           = @{"hasSensitiveData" = $false; "sensitiveData" = $ParamList.Password }
        promptForPassword      = $ParamList.PromptForPassword
        userName               = $ParamList.Username
    }

    return $data
}

function PrivateKey {
    PARAM ( $ParamList )
    
    $data = @{
        allowClipboard                        = $false
        allowViewPasswordAction               = $false
        privateKeyAutomaticallyLoadToKeyAgent = $false
        privateKeyData                        = $ParamList.PrivateKeyCtx.Body.privateKeyData
        privateKeyFileName                    = ""
        privateKeyOverridePasswordItem        = if ($ParamList.Password) { @{"hasSensitiveData" = $false; "sensitiveData" = $ParamList.Password } } else { $null }
        privateKeyOverrideUsername            = if ($ParamList.Username) { $ParamList.Username }  else { $null }
        privateKeyOverridePhraseItem          = if ($ParamList.PrivateKeyPassphrase) { @{"hasSensitiveData" = $false; "sensitiveData" = $ParamList.PrivateKeyPassphrase } } else { $null }
        privateKeyPromptForPassPhrase         = $ParamList.PromptForPassphrase
        privateKeyType                        = $ParamList.PrivateKeyType
        credentials                           = $null
    }

    return $data
}
