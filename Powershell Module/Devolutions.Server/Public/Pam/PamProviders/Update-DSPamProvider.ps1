function Update-DSPamProvider {
    <#
    .SYNOPSIS
    Update a PAM Provider with given values.
    .DESCRIPTION
    Update a PAM Provider with given parameters. Goes through every parameter and check if 
    key match a key in current Provider data. If so, updates current Provider data and send 'PUT' web request.
    .EXAMPLE
    #>
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [guid]$candidProviderID,
        [string]$name,
        [guid]$ProviderID,
        [int]$checkoutApprovalMode,
        [int]$checkoutReasonMode,
        [int]$allowCheckoutOwnerAsApprover,
        [int]$includeAdminsAsApprovers,
        [int]$includeManagersAsApprovers,
        [int]$checkoutTime
    )
    BEGIN {
        Write-Verbose '[Update-DSPamProvider] Begin...'

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    PROCESS {
        try {
            $URI = "$Script:DSBaseURI/api/pam/Providers/$candidProviderID"

            #Getting Provider infos
            $params = @{
                Uri    = $URI
                Method = 'GET'
            }
            $res = Invoke-DS @params

            if ($res.Body) {
                $ProviderInfos = @{}
                foreach ($property in $res.Body.PSObject.Properties) {
                    $ProviderInfos[$property.Name] = $property.Value
                }
            }
            else {
                Write-Verbose "[Update-DSPamProvider] Provider couldn't be found. Make sure that you are using the correct Provider ID and try again."
            }   

            $PSBoundParameters.GetEnumerator() | ForEach-Object {
                if ($ProviderInfos.ContainsKey($_.Key)) {
                    $isValid = $true

                    switch ($_) {
                        ($_.Key -eq 'allowCheckoutOwnerAsApprover') { 
                            if ($_.Value -notin (0, 1, 2) ) { $isValid = $false }
                        }
                        ($_.Key -eq 'checkoutApprovalMode') { 
                            if ($_.Value -notin (0, 1, 2) ) { $isValid = $false }
                        }
                        ($_.Key -eq 'checkoutReasonMode') { 
                            if ($_.Value -notin (0, 1, 2 , 3) ) { $isValid = $false }
                        }                        
                        ($_.Key -eq 'includeAdminsAsApprovers') {
                            if ($_.Value -notin (0, 1, 2) ) { $isValid = $false }
                        }
                        ($_.Key -eq 'includeManagersAsApprovers') {
                            if ($_.Value -notin (0, 1, 2) ) { $isValid = $false }
                        }        
                    }

                    if ($isValid) {
                        $ProviderInfos[$_.Key] = $_.Value
                    }
                    else {
                        #Todo: Invalid param
                        Write-Host "Shouldnt see this"
                    }
                }
            }
            
            $params = @{
                Uri    = $URI
                Method = 'PUT'
                Body   = $ProviderInfos | ConvertTo-Json
            }
            $res = Invoke-DS @params
            return $res
        }
        catch { 
            $exc = $_.Exception
            If ([System.Management.Automation.ActionPreference]::Break -ne $DebugPreference) {
                Write-Debug "[Exception] $exc"
            } 
        }
    }
    END {
        If ($res.isSuccess) {
            Write-Verbose '[New-DSPamProviders] Completed Successfully.'
        }
        else {
            Write-Verbose '[New-DSPamProviders] Ended with errors...'
        }
    }
}