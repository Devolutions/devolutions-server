function New-DSCredentialEntry {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .NOTES
    #>

    PARAM (
        [hashtable]$ParamList
    )

    BEGIN {
        Write-Verbose '[New-DSEntry] Beginning...'

        $URI = "$Global:DSBaseURI/api/connections/partial/save"
        $Method = "POST"
    
        $SupportedSubType = @(
            [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::Default,
            [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::PrivateKey
        )

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }

    PROCESS {
        try {
            if ($ParamList.ConnectionSubType -notin $SupportedSubType) {
                throw "Credential of type $($ParamList.ConnectionSubType) are not supported yet."
            }

            #Validate if vault exists
            if ((Set-DSVaultsContext $ParamList.VaultID).Body.result -ne [Devolutions.RemoteDesktopManager.SaveResult]::Success) { 
                throw [System.Management.Automation.ItemNotFoundException]::new("Vault could not be found. Please make sure you provide a valid vault ID.") 
            } 

            #Validate private key, if path was provided
            if (![string]::IsNullOrEmpty($ParamList.PrivateKeyPath)) { 
                $PrivateKeyCtx = Confirm-PrivateKey $ParamList.PrivateKeyPath
                if ($PrivateKeyCtx.Body.result -ne [Devolutions.RemoteDesktopManager.SaveResult]::Success) {
                    throw [System.Management.Automation.ItemNotFoundException]::new("Private key could not be parsed. Please make sure you provide a valid .ppk file.") 
                }
                $ParamList.Add("PrivateKeyCtx", $PrivateKeyCtx)
            }  

            #Get the encrypted data, such as username/password/privatekey content/passphrase/etc...
            $EncryptedDataSegment = New-DSDataSegment $ParamList

            #Get "events" segment
            $EventsSegment = New-DSCredentialEventsSegment $ParamList

            #Prepare request body (parts of partialConnection object)
            $CredentialBody = @{
                checkOutMode      = $ParamList.CheckoutMode
                group             = $Folder
                connectionType    = 26
                connectionSubType = $ParamList.ConnectionSubType.ToString()
                data              = $EncryptedDataSegment
                repositoryId      = $ParamList.VaultID
                name              = $ParamList.EntryName
                events            = $EventsSegment
                description       = $ParamList.Description
                keywords          = $ParamList.Tags
                expiration        = $ParamList.Expiration
            }

            $RequestParams = @{
                URI    = $URI
                Method = $Method
                Body   = $CredentialBody | ConvertTo-Json
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            $Exception = $_.Exception
        }
    }

    END {
        if ($res.isSuccess) {
            Write-Verbose "[New-DSCredentialEntry] Completed successfully!"
        }
        else {
            Write-Verbose "[New-DSCredentialEntry] Ended with errors..."
            Write-Error $Exception.Message
        }
    } 
}