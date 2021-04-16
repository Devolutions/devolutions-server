function Update-DSCredentialEntry {
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$CandidEntryID,

        #Base credential data
        [string]$name,
        [string]$username,
        [string]$domain,
        [string]$group,
        [string]$description,
        [string]$keywords
    )

    BEGIN {
        Write-Verbose "[Update-DSCredentialEntry] Begining..."

        $URI = "$Script:DSBaseUri/api/connections/partial/save"


        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            #Get cred ctx
            $CredCtx = Get-DSEntry -EntryId $CandidEntryID -IncludeAdvancedProperties

            #Validate if cred exists, if not throw ItemNotFound
            if (!$CredCtx.isSuccess) {
                throw [System.Management.Automation.ItemNotFoundException]::new("Entry could not be found. Please make sure you provide an existing entry ID.") 
            }

            #Sets the current credential data to compare with $PSBoundParameters
            $CredData = $CredCtx.Body.data

            foreach ($param in $PSBoundParameters.GetEnumerator()) {
                if ($param.Key -ne 'CandidEntryID') {
                    if ($param.Value -ne $CredData.($param.Key)) {
                        $CredData.($param.Key) = $param.Value
                    }
                }
            }

            $Params = @{
                URI    = $URI
                Method = "PUT"
                Body   = $CredData | ConvertTo-Json
            }

            $Res = Invoke-DS @Params -Verbose
            return $Res
        }
        catch {
            $Exception = $_.Exception
            Write-Error $Exception.Message
        }
    }

    END {
        if ($? -and $res.isSuccess) {
            Write-Verbose "[Update-DSCredentialEntry] Completed successfully!"
        }
        else {
            Write-Verbose "[Update-DSCredentialEntry] Ended with errors..."
            Write-Debug $Exception.Message
        }
    }
}