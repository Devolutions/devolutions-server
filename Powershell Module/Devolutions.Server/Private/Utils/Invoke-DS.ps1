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

        [string]$ContentType = 'application/json',

        [string]$body,

        [switch]$LegacyResponse
    )

    BEGIN {
        Write-Verbose '[Invoke-DS] begin...'

        if (!(Get-Variable DSSessionToken -Scope Global -ErrorAction SilentlyContinue) -or ([string]::IsNullOrWhiteSpace($Global:DSSessionToken))) {
            throw 'Session does not seem authenticated, call New-DSSession.'
        }

        $PSBoundParameters.Add('WebSession', $Global:WebSession)
        if (!($PSBoundParameters.ContainsKey('ContentType'))) { $PSBoundParameters.Add('ContentType', $ContentType) }
        $PSBoundParameters.Remove('LegacyResponse') | out-null
    }

    PROCESS {
        try {
            $response = Invoke-WebRequest @PSBoundParameters -ErrorAction Stop

            if ($LegacyResponse) {
                $res = Convert-LegacyResponse $response
            }
            else {
                $res = New-ServerResponse -response $response -method $method
            }
    
            return $res
        }
        catch [System.UriFormatException] {
            throw 'Not initialized, please use New-DSSession'
        }
        catch {
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::SilentlyContinue -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            }

            #Some exceptions comes with proper error message (Such as "Name is already used." when trying to save a PAM folder with an already used name.). If that's
            #the case, I make sure to add it to the returned ServerResponse. If I don't, the error message will read the default message generated by Invoke-WebRequest.
            if ($_.ErrorDetails) {
                try {
                    return [ServerResponse]::new($false, $exc.Response, $null, $exc, ($_.ErrorDetails.Message | ConvertFrom-JSon).message, $exc.Response.StatusCode)                       
                }
                catch {
                    return [ServerResponse]::new($false, $exc.Response, $null, $exc, $exc.Message, $exc.Response.StatusCode)                        
                }
            }
            else {
                #If $_ErrorDetails doesn't exist, it just sends back the exception originating from Invoke-WebRequest
                Write-Debug "Error might not have been handled properly. Trace Invoke-DS to make sure error couldn't be handlded in a more elegant way."
                return [ServerResponse]::new($false, $exc.Response, $null, $exc, $exc.Message, $exc.Response.StatusCode) 
            }
        }
    }

    END {
        If ($?) {
            Write-Verbose '[Invoke-DS] Completed Successfully.'
        }
        else {
            Write-Verbose '[Invoke-DS] Ended with errors...'
        }
    }
}