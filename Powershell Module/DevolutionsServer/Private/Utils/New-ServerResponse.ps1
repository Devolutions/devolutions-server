function New-ServerResponse {
    <#
.SYNOPSIS
Returns a new ServerResponse object.

.DESCRIPTION
In order to forge an appropriate server response, this CMDlet looks at the request method, then 
at the request URI absolute path. It then sends an appropriate response using (usually) the HTTP response's body.

.NOTES
Endpoint with params return 400 if no resource were found matching supplied params. 400 generates an exception and is handled
by Invoke-DS. Maybe it could be useful to redirect here instead and return a custom error message for each resource that failed
to be found.
#>





    [CmdletBinding()]
    [OutputType([ServerResponse])]
    param(
        [Parameter(Mandatory)]
        [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject]$response,
        [Parameter(Mandatory)]
        [string]$method
    )
    PROCESS {
        switch ($method) {
            "GET" {
                $requestedResource = $response.BaseResponse.RequestMessage.RequestUri.AbsolutePath
                switch -Wildcard ($requestedResource) {
                    '/dvls/api/pam/checkout-policies' {
                        if ($response.Content -eq '[]') {
                            #404 no account found.
                            return [ServerResponse]::new($false, $response, ($response.Content | ConvertFrom-JSon), $null, "No checkout policies were found. Make sure you have at least one checkout policy in place.", 404)
                        }
                        else {
                            #200 resource(s) found.
                            return [ServerResponse]::new($true , $response, ($response.Content | ConvertFrom-JSon), $null, $null, 200)
                        } 
                    }
                    '/dvls/api/pam/checkout-policies/count' { 
                        if ($response.Content -eq '0') {
                            #404 no account found.
                            return [ServerResponse]::new($false, $response, ($response.Content | ConvertFrom-JSon), $null, "No checkout policies were found. Make sure you have at least one checkout policy in place.", 404)
                        }
                        else {
                            #200 resource(s) found.
                            return [ServerResponse]::new($true , $response, ($response.Content | ConvertFrom-JSon), $null, $null, 200)
                        } 
                    }
                    '/dvls/api/pam/checkout-policies/*' {
                        return [ServerResponse]::new($true , $response, ($response.Content | ConvertFrom-JSon), $null, $null, 200)
                        
                    }

                    '/dvls/api/pam/credentials' {
                        if ($response.Content -eq '[]') {
                            #404 no account found.
                            return [ServerResponse]::new($false, $response, ($response.Content | ConvertFrom-JSon), $null, "No PAM accounts found. Make sure you have the correct folderID and have created PAM accounts.", 404)
                        }
                        else {
                            #200 resource(s) found.
                            return [ServerResponse]::new($true , $response, ($response.Content | ConvertFrom-JSon), $null, $null, 200)
                        }
                    }
                    Default { return [ServerResponse]::new($false , $response, ($response.Content | ConvertFrom-JSon), $null, "[GET] Couldn't locate an appropriate response. If you see this, contact your system administrator for help.", 200) }
                }                
            }
            "POST" {
                if ($response.StatusCode -eq 201) {
                    return [ServerResponse]::new($true, $response, ($response.Content | ConvertFrom-JSon), $null, "", 201)
                }
                else {
                    return [ServerResponse]::new(($response.StatusCode -eq 200), $response, ($response.Content | ConvertFrom-JSon), $null, "", $response.StatusCode)
                }
            }
            "DELETE" {
                if ($response.StatusCode -eq 204) {
                    return [ServerResponse]::new($true, $response, ($response.Content | ConvertFrom-JSon), $null, "", 204)
                }
                else {
                    return [ServerResponse]::new($false, $response, ($response.Content | ConvertFrom-JSon), $null, "", $response.StatusCode)
                }
            }
            "PUT" {
                return [ServerResponse]::new(($response.StatusCode -eq 200), $response, ($response.Content | ConvertFrom-JSon), $null, "", $response.StatusCode)
            }
            #Status 418: Should never get this response. If so, update switchcase so you don't.
            Default { return [ServerResponse]::new(($false), $response, ($response.Content | ConvertFrom-JSon), $null, "Please contact your system administrator for help.", 418) }
        }
    }
}