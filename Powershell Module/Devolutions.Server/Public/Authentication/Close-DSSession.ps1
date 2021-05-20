function Close-DSSession {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        Write-Verbose '[Close-DSSession] Beginning...'
        $VarsToClear = @('DSInstanceName', 'DSInstanceVersion', 'DSSafeSessionKey', 'DSSessionKey', 'DSBaseURI')
    }
    
    process {
        $RequestParams = @{
            URI    = "$Script:DSBaseURI/api/logout"
            Method = 'GET'
        }

        try {
            Invoke-WebRequest @RequestParams -WebSession $Global:WebSession
        }
        catch {
            Write-Warning '[Close-DSSession] No session was previously established.'
        }

        $VarsToClear.GetEnumerator() | ForEach-Object {
            try {
                if ($_ -eq 'DSBaseURI') { Remove-Variable $_ -Scope Script -ErrorAction SilentlyContinue -Force } else { Remove-Variable $_ -Scope Global -ErrorAction SilentlyContinue -Force }
            }
            catch {
                Write-Warning "[Close-DSSession] Error while clearing $_..."
            }
        }

    }
    
    end {
        Write-Verbose '[Close-DSSession] Done.'
    }
}