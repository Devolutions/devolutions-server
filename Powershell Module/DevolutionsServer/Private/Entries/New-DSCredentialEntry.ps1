function New-DSCredentialEntry {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .NOTES
    #>

    PARAM (
        #test
        $ParamList
    )

    BEGIN {
        Write-Verbose '[New-DSEntry] Begining...'

        $URI = "$Script:DSBaseURI/api/connections/partial/save"
        $Method = "PUT"
    
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
            
            #Validate private key
            $PrivateKeyCtx = Confirm-PrivateKey $ParamList.PrivateKeyPath
            if (![string]::IsNullOrEmpty($ParamList.PrivateKeyPath) -and $PrivateKeyCtx.Body.result -ne [Devolutions.RemoteDesktopManager.SaveResult]::Success) { 
                throw [System.Management.Automation.ItemNotFoundException]::new("Private key could not be parsed. Please make sure you provide a valid .ppk file.") 
            }  

            #Get base segment for credentials
            $CredentialSegmentData = @{
                Username          = $ParamList.Username
                Password          = $ParamList.Password
                UserDomain        = $ParamList.Domain
                MnemonicPassword  = $ParamList.MnemonicPassword
                PromptForPassword = $ParamList.PromptForPassword
            }
            $CredentialSegment = New-DSCredentialSegment @CredentialSegmentData

            #Get "events" (log) segment
            $EventsSegmentData = @{
                CredentialViewedCommentIsRequired        = $ParamList.CredentialViewedCommentIsRequired
                CredentialViewedPrompt                   = $ParamList.CredentialViewedPrompt
                TicketNumberIsRequiredOnCredentialViewed = $ParamList.TicketNumberIsRequiredOnCredentialViewed
            }
            $EventsSegment = New-DSCredentialEventsSegment @EventsSegmentData
  
            #Prepare data for encryption
            $EntryData = $CredentialSegment + @{
                group          = $ParamList.Folder
                connectionType = 26
                repositoryID   = $ParamList.VaultID
                name           = $ParamList.EntryName
                privateKeyData = if ($PrivateKeyCtx.isSuccess) { $PrivateKeyCtx.Body.privateKeyData } else { $null }
                privateKeyType = if ($PrivateKeyCtx.isSuccess) { $ParamList.PrivateKeyType } else { $null }
            }
            $EncryptedEntryData = Protect-ResourceToHexString ($EntryData | ConvertTo-Json)

            $CredentialBody = @{
                checkOutMode      = $ParamList.CheckoutMode
                group             = $Folder
                connectionType    = 26
                connectionSubType = $ParamList.ConnectionSubType.ToString()
                data              = $EncryptedEntryData
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