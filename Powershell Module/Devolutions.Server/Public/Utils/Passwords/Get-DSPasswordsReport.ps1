function Get-DSPasswordsReport {
    [CmdletBinding()]
    PARAM (
        [ValidateNotNullOrEmpty()]
        [guid]$VaultID = [guid]::Empty,
        [ValidateNotNullOrEmpty()]
        [string]$OutputPath = $(throw 'You must supply an output path (including file ending in .csv) in order to generate the report.')
    )
    
    BEGIN {
        Write-Verbose '[Get-PasswordsReport] Beginning...'
        $IsSuccess = $true
        $ClearPasswords = @()
    }
    
    PROCESS {
        $EntriesWithPassword = @()
        $CurrentPage = 1
        $TotalPages = 1

        try {
            do {
                $res = Invoke-DS -URI "$Script:DSBaseURI/api/v3/reports/password-analyzer?vaultId=$VaultID&pageNumber=$currentPage&pageSize=100" -method 'GET' -Verbose
                $TotalPages = $res.Body.totalPage
                $EntriesWithPassword += $res.Body.data
                $CurrentPage++
            } while ($CurrentPage -le $TotalPages)

            #If user can access password-analyzer
            if ($EntriesWithPassword.Count -gt 0) {
                #Loop each entry with a password
                $EntriesWithPassword.GetEnumerator() | ForEach-Object {
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