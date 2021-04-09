function Invoke-DS {
    <#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.NOTES

.LINK
#>
    [CmdletBinding()]
    [OutputType([ServerResponse])]
    param(			
        [Parameter(Mandatory)]
        [ValidateSet('Get', 'Post', 'Put', 'Delete')]
        [string]$method,

        [Parameter(Mandatory)]
        [string]$URI,

        [string]$body,

        [switch]$LegacyResponse
    )

    BEGIN {
        Write-Verbose '[Invoke-DS] begin...'

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
        
        $PSBoundParameters.Add("WebSession", $Script:WebSession)
        $PSBoundParameters.Add("ContentType", 'application/json')
        $PSBoundParameters.Remove('LegacyResponse') | out-null
    }

    PROCESS {
        try {
            $response = Invoke-WebRequest @PSBoundParameters -Headers @{'tokenId' = $Script:DSSessionToken } -ErrorAction Stop
        }
        catch [System.UriFormatException] {
            throw "Not initialized, please use New-DSSession"
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            }

            if ($_.ErrorDetails) {
                #delete users error contains ErrorDetails.Message
                return [ServerResponse]::new($false, $null, $null, $exc, ($_.ErrorDetails.Message | ConvertFrom-JSon).message, $exc.Response.StatusCode)                        
            }
            else {
                #delete checkout policy is missing an error message, probably not the only one so going generic
                return [ServerResponse]::new($false, $null, $null, $exc, "Resource couldn't be found or error not yet handled.", 404) 
            }
        }
        
        if ($LegacyResponse) {
            $res = Convert-LegacyResponse $response
        }
        else {
            $res = New-ServerResponse $response $method 
        }

        return $res

    } #PROCESS

    END {
        If ($res.isSuccess) {
            Write-Verbose '[Invoke-DS] Completed Successfully.'
        }
        else {
            Write-Verbose '[Invoke-DS] Ended with errors...'
        }
    } #END
}