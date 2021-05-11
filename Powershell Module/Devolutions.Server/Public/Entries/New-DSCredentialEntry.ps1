function New-DSCredentialEntry {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE

    .NOTES
    #>

    [CmdletBinding()]
        PARAM (
            [ValidateNotNullOrEmpty()]
            #Connection sub-type. Used for connections of type Credentials. (Supported sub-type are Default or PrivateKey)
            [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]$ConnectionSubType = [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::Default,
        
            #Entry's name
            [ValidateNotNullOrEmpty()]
            [string]$EntryName,
            #Entry's domain
            [string]$Domain,
            [ValidateNotNullOrEmpty()]
            #Entry's username
            [string]$Username,
            #Entry's password
            [string]$Password,
            #Entry's mnemonic passwordF
            [string]$MnemonicPassword,
            #Entry's vault ID
            [guid]$VaultID = [guid]::Empty,
            #Entry's location in the vault (Folder name, not ID)
            [string]$Folder,
            #Entry's prompt for password when checkout
            [bool]$PromptForPassword,
        
            <# -- More tab -- #>
    
            #Entry's description
            [string]$Description,
            #Entry's tags (Keywords). Each word separeted by a space is considered a keyword.
            [string]$Tags,
            #Entry's expiration date (ISO-8601 format (yyyy-mm-ddThh:mm:ss.000Z)
            [string]$Expiration,
    
            <# -- Events tab -- #>
    
            #A comment is required to view entry's credentials
            [bool]$CredentialViewedCommentIsRequired = $False,
            #A ticket number is required to view entry's credentials
            [bool]$TicketNumberIsRequiredOnCredentialViewed = $False,
            #Prompt the user for comment/ticket number
            [bool]$CredentialViewedPrompt = $False,
    
            <# -- Security tab -- #>
    
            #Entry's checkout mode
            [Devolutions.RemoteDesktopManager.CheckOutMode]$CheckoutMode = [Devolutions.RemoteDesktopManager.CheckOutMode]::Default,
            #Entry's offline mode
            [Devolutions.RemoteDesktopManager.AllowOffline]$AllowOffline = [Devolutions.RemoteDesktopManager.AllowOffline]::Default,
    
            <# -- PrivateKey specifics... -- #>
            
            #Private key type
            [ValidateSet('NoKey', 'Data')]
            [Devolutions.RemoteDesktopManager.PrivateKeyType]$PrivateKeyType = [Devolutions.RemoteDesktopManager.PrivateKeyType]::Data,
            #Full private key path (*.ppk)
            [string]$PrivateKeyPath,
            #Private key passphrase
            [string]$PrivateKeyPassphrase,
            #Prompt for passphrase before checkout
            [bool]$PromptForPassphrase
    )

    BEGIN {
        Write-Verbose '[New-DSCredentialEntry] Beginning...'

        $SupportedSubType = @(
            [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::Default,
            [Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::PrivateKey
        )
    }

    PROCESS {
        try {
            $ParamList = Get-ParameterValues
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

            $res = New-DSEntryBase -Body $CredentialBody
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