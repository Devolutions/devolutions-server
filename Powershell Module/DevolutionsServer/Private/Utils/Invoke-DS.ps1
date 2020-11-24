function Invoke-DS{
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

        if ([string]::IsNullOrWhiteSpace($Script:DSSessionToken))
        {
            throw "Session does not seem authenticated, call New-DSSession."
        }
        
        $PSBoundParameters.Add("WebSession", $Script:WebSession)
        $PSBoundParameters.Add("ContentType", 'application/json')
        $PSBoundParameters.Remove('LegacyResponse') | out-null
    }

    PROCESS {
		try {
			$response = Invoke-WebRequest @PSBoundParameters -ErrorAction Stop
		}
		catch [System.UriFormatException] {
            throw "Not initialized, please use New-DSSEssion"
		}
		catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                    Write-Debug "[Exception] $exc"
            } 
            return [ServerResponse]::new($false, $null, $null, $exc, "", $exc.Response.StatusCode)                        
        }
        
        if ($LegacyResponse)
        {
            return Convert-LegacyResponse $response
        }
        else {
            return [ServerResponse]::new(($response.StatusCode -eq 200), $response, ($response.Content | ConvertFrom-JSon), $null, "", $response.StatusCode)
        }

	} #PROCESS

    END {
        If ($?) {
            Write-Verbose '[Invoke-DS] Completed Successfully.'
        } else {
            Write-Verbose '[Invoke-DS] ended with errors...'
        }
    } #END
}