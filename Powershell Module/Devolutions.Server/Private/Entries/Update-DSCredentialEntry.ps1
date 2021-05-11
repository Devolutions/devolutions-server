function Update-DSCredentialEntry {
    [CmdletBinding()]
    PARAM (
        [hashtable]$ParamList
    )
    
    BEGIN {
        Write-Verbose "[Update-DSCredentialEntry] Beginning..."

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $EntryResolvedVariables = (Get-DSEntry -EntryId $CandidEntryID -IncludeAdvancedProperties).Body.data
            $EntrySensitiveData = (Get-DSEntrySensitiveData $CandidEntryID).Body.data

            switch ($EntryResolvedVariables.connectionSubType) {
                ([Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::Default) { Update-UsernamePassword $ParamList $EntryResolvedVariables $EntrySensitiveData }
                ([Devolutions.RemoteDesktopManager.CredentialResolverConnectionType]::PrivateKey) { Update-PrivateKey $ParamList $EntryResolvedVariables $EntrySensitiveData }
                Default { throw "Credential $($EntryResolvedVariables.connectionSubType) not supported." }
            }

            $RequestParams = @{
                Uri = "$Script:DSBaseURI/api/connections/partial/save"
                Method = "PUT"
                Body   = $EntryResolvedVariables | ConvertTo-Json
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose "[Update-DSCredentialEntry] Completed successfully!"
        }
        else {
            Write-Verbose "[Update-DSCredentialEntry] Ended with errors..."
        }
    }
}

function Update-UsernamePassword {
    PARAM (
        [hashtable]$ParamList,
        $EntryResolvedVariables,
        $EntrySensitiveData
    )
    $ISORegex = "/^(-?(?:[1-9][0-9]*)?[0-9]{4})-(1[0-2]|0[1-9])-(3[01]|0[1-9]|[12][0-9])T(2[0-3]|[01][0-9]):([0-5][0-9]):([0-5][0-9])(.[0-9]+)?(Z)?$/g"

    foreach ($Param in $ParamList.GetEnumerator()) {
        if (($null -ne $Param.Value) -and (![string]::IsNullOrWhiteSpace($Param.Value))) {
            switch ($Param.Key) {
                "EntryName" {
                    if ($Param.Value -ne $EntryResolvedVariables.name) { 
                        $EntryResolvedVariables.name = $Param.Value 
                    }
                }
                "Folder" { 
                    if ($Param.Value -ne $EntryResolvedVariables.group) {
                        $EntryResolvedVariables.group = $Param.Value 
                    } 
                }
                "Username" { 
                    if ($Param.Value -ne $EntryResolvedVariables.data.userName) {
                        $EntryResolvedVariables.data.userName = $Param.Value 
                    }
                }
                "Domain" {
                    if ($Param.Value -ne $EntryResolvedVariables.data.domain) {
                        $EntryResolvedVariables.data.domain = $Param.Value 
                    }
                }
                "Password" {
                    if ($Param.Value -ne $EntryResolvedVariables.data.passwordItem) { 
                        @{"hasSensitiveData" = $True; "sensitiveData" = $Param.Value } | Out-Null 
                    }
                }
                "PromptForPassword" { 
                    if ("promptForPassword" -in $EntryResolvedVariables.data.PSObject.Properties.Name) {
                        $EntryResolvedVariables.data.promptForPassword = $Param.Value
                    }
                    else {
                        $EntryResolvedVariables.data | Add-Member -NotePropertyName "promptForPassword" -NotePropertyValue $Param.Value
                    }
                }
                "MnemonicPassword" {
                    if ($Param.Value -ne $EntryResolvedVariables.data.mnemonicPassword) {
                        $EntryResolvedVariables.data.mnemonicPassword = $Param.Value 
                    }
                }

                "Description" {
                    if ($Param.Value -ne $EntryResolvedVariables.description) {
                        $EntryResolvedVariables.description = $param.Value
                    } 
                }
                "Tags" { 
                    if ($Param.Value -ne $EntryResolvedVariables.keywords) {
                        $EntryResolvedVariables.keywords = $Param.Value
                    }
                }
                "Expiration" {
                    if (($Param.Value -ne $EntryResolvedVariables.expiration) -and $Param.Value -match $ISORegex) {
                        $EntryResolvedVariables.description = $param.Value
                    }  
                }

                "CredentialViewedCommentIsRequired" {
                    if ("credentialViewedCommentIsRequired" -in $EntryResolvedVariables.events.PSObject.Properties.Name) {
                        $EntryResolvedVariables.events.credentialViewedCommentIsRequired = $Param.Value 
                    }
                }
                "CredentialViewedPrompt" {
                    if ("credentialViewedPrompt" -in $EntryResolvedVariables.events.PSObject.Properties.Name) { 
                        $EntryResolvedVariables.events.credentialViewedPrompt = $Param.Value 
                    }
                }
                "TicketNumberIsRequiredOnCredentialViewed" {
                    if ("ticketNumberIsRequiredOnCredentialViewed" -in $EntryResolvedVariables.events.PSObject.Properties.Name) {
                        $EntryResolvedVariables.events.ticketNumberIsRequiredOnCredentialViewed = $Param.Value 
                    }
                }
                Default {}
            }
        }
    }
    
    $EntryResolvedVariables.data = Protect-ResourceToHexString ($EntryResolvedVariables.data | ConvertTo-Json)
}

function Update-PrivateKey {
    <#
        .NOTES
        Missing Tags, Expiration, CheckoutMode and AllowOffline
    #>
    PARAM (
        [hashtable]$ParamList,
        $EntryResolvedVariables,
        $EntrySensitiveData
    )
    
    #Validate private key, if path was provided. If it exists, replace current ppk data with new ppk data
    if (![string]::IsNullOrEmpty($ParamList.PrivateKeyPath)) { 
        $PrivateKeyCtx = Confirm-PrivateKey $ParamList.PrivateKeyPath

        if ($PrivateKeyCtx.Body.result -ne [Devolutions.RemoteDesktopManager.SaveResult]::Success) {
            throw [System.Management.Automation.ItemNotFoundException]::new("Private key could not be parsed. Please make sure you provide a valid .ppk file.") 
        }

        $EntryResolvedVariables.data.privateKeyData = $PrivateKeyCtx.Body.privateKeyData
    }

    foreach ($Param in $ParamList.GetEnumerator()) {
        switch ($Param.Key) {
            "Username" {
                $EntryResolvedVariables.userName = $Param.Value
                if ($Param.Value -ne $EntryResolvedVariables.data.privateKeyOverrideUsername) { $EntryResolvedVariables.data.privateKeyOverrideUsername = $Param.Value }
            }
            "Password" { 
                if ($Param.Value -ne $EntrySensitiveData.privateKeyOverridePasswordItem.sensitiveData) { $EntryResolvedVariables.data.privateKeyOverridePasswordItem = @{"hasSensitiveData" = $true; "sensitiveData" = $Param.Value } }
            }
            "PrivateKeyPassphrase" {
                if ($Param.Value -ne $EntrySensitiveData.privateKeyPassPhraseItem.sensitiveData) { $EntryResolvedVariables.data.privateKeyOverridePasswordItem = @{"hasSensitiveData" = $true; "sensitiveData" = $Param.Value } }
            }
            "PromptForPassphrase" {
                if ("privateKeyPromptForPassPhrase" -in $EntryResolvedVariables.data.PSObject.Properties.Name) { $EntryResolvedVariables.data.privateKeyPromptForPassPhrase = $Param.Value }
                else { $EntryResolvedVariables.data | Add-Member -NotePropertyName "privateKeyPromptForPassPhrase" -NotePropertyValue $Param.Value }
            }
            "PrivateKeyType" {
                if ($Param.Value.value__ -ne $EntryResolvedVariables.data.privateKeyType) { $EntryResolvedVariables.data.privateKeyType = $Param.Value.value__ }
            }

            "VaultID" {
                if ($Param.Value -ne $EntryResolvedVariables.repositoryId) { $EntryResolvedVariables.repositoryId = $Param.Value }
            }
            "Folder" {
                if ($Param.Value -ne $EntryResolvedVariables.group) { $EntryResolvedVariables.group = $Param.Value }
            }
            "EntryName" {
                if ($Param.Value -ne $EntryResolvedVariables.name) { $EntryResolvedVariables.name = $Param.Value }
            }

            "CredentialViewedCommentIsRequired" {
                if ("credentialViewedCommentIsRequired" -in $EntryResolvedVariables.events.PSObject.Properties.Name) { $EntryResolvedVariables.events.credentialViewedCommentIsRequired = $Param.Value }
            }
            "CredentialViewedPrompt" {
                if ("credentialViewedPrompt" -in $EntryResolvedVariables.events.PSObject.Properties.Name) { $EntryResolvedVariables.events.credentialViewedPrompt = $Param.Value }
            }
            "TicketNumberIsRequiredOnCredentialViewed" {
                if ("ticketNumberIsRequiredOnCredentialViewed" -in $EntryResolvedVariables.events.PSObject.Properties.Name) { $EntryResolvedVariables.events.ticketNumberIsRequiredOnCredentialViewed = $Param.Value }
            }

            Default { 
                if (($Param.Key -in $EntryResolvedVariables.PSObject.Properties.Name) -and ($Param.Value -ne $EntryResolvedVariables.($Param.Key))) { 
                    $EntryResolvedVariables.($Param.Key) = $Param.Value 
                }
            }
        }
    }

    $EntryResolvedVariables.data = Protect-ResourceToHexString ($EntryResolvedVariables.data | ConvertTo-Json)
}