function Get-DSPasswordsReport {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = $(throw 'You must supply an output path (including file ending in .csv) in order to generate the report.')
    )
    
    BEGIN {
        Write-Verbose '[Get-PasswordsReport] Beginning...'
        $IsSuccess = $true
        $ClearPasswords = @()
        $URI = "$env:DS_URL/api/v3/reports/password-analyzer"
    }
    
    PROCESS {
        $RequestParams = @{
            URI    = $URI
            Method = 'GET'
        }

        try {
            #If user can access password-analyzer
            if (($res = Invoke-DS @RequestParams -Verbose).isSuccess) {
                $EntriesWithPassword = $res.Body.data.GetEnumerator()
                #Loop each entry with a password
                $EntriesWithPassword | ForEach-Object {
                    #If fetching sensitivedata for entry was successful
                    if (($res = Get-DSEntrySensitiveData -EntryId $_.id).isSuccess) {
                        $SensitiveData = $res.Body.data

                        $ClearPasswords += New-Object PSObject -Property @{
                            'Entry name' = $_.name
                            'Path'       = $_.group
                            'Password'   = $SensitiveData.credentials.password
                        }
                    }
                    else {
                        Write-Warning "[Get-PasswordsReport] Error while fetching sensitive data for $($_.name)"
                    }
                }
            }
            else {
                $IsSuccess = $false
                throw '[Get-PasswordsReport] No entries with password were found.'
            }

            $ClearPasswords | Export-Csv -Path $OutputPath -Force
        }
        catch {
            $IsSuccess = $false
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($IsSuccess) {
            Write-Verbose '[Get-PasswordsReport] Completed successfully!'
        }
        else {
            Write-Verbose '[Get-PasswordsReport] Ended with errors...'
        }
    }
}