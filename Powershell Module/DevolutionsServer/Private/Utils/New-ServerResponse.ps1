function New-ServerResponse {
    <#
.SYNOPSIS
Returns a new ServerResponse object.

.DESCRIPTION
In order to forge an appropriate server response, this CMDlet looks at the request method. It then sends an appropriate response using (usually) the HTTP response's body.

.NOTES
Endpoint with params return 400 if no resource were found matching supplied params. 400 generates an exception and is handled
by Invoke-DS. Maybe it could be useful to redirect here instead and return a custom error message for each resource that failed
to be found.
#>
    [CmdletBinding()]
    [OutputType([ServerResponse])]
    param(
        [Parameter(Mandatory)]
        $response,
        [Parameter(Mandatory)]
        [string]$method
    )
    PROCESS {
        $responseContentJson = $response.Content | ConvertFrom-Json
        if ($null -eq $responseContentJson) {
            $HasResult = $false
        } else {
            $HasResult = Get-Member -InputObject $responseContentJson -Name "result"
        }

        switch ($method) {
            "GET" {
                #patch
                if (($null -ne $responseContentJson) -and ($HasResult)) {
                    switch ($responseContentJson.result) {
                        ( [Devolutions.RemoteDesktopManager.SaveResult]::Error.value__ ) { 
                            return [ServerResponse]::new($false , $response, $null, $null, "TODO: Unhandled error.", 500) 
                        }
                        ( [Devolutions.RemoteDesktopManager.SaveResult]::Success.value__ ) { 
                            return [ServerResponse]::new($true , $response, $responseContentJson, $null, $null, 200) 
                        }
                        ( [Devolutions.RemoteDesktopManager.SaveResult]::NotFound.value__ ) { 
                            return [ServerResponse]::new($false , $response, $null, $null, "Resource couldn't be found.", 404) 
                        }
                        Default { return [ServerResponse]::new($false , $response, $null, $null, "[GET] Unhandled error. If you see this, please contact your system administrator for help.", 200) }
                    }
                }
                else {
                    if ($response.StatusCode -eq 200) {
                        if ($null -ne $responseContentJson) {
                            return [ServerResponse]::new($true , $response, $responseContentJson, $null, $null, $response.StatusCode)
                        }
                        else {
                            return [ServerResponse]::new($true , $response, $response.Content, $null, $null, $response.StatusCode)
                        }
                    }
                    else {
                        return [ServerResponse]::new($false , $response, $response.Content, $null, "[GET] Unhandled error. If you see this, please contact your system administrator for help.", 200)
                    }
                }                
            }
            "POST" {
                if (($null -ne $responseContentJson) -and ($HasResult)) {
                    #Get-DSEntrySensitiveData uses POST although the correct verb would be GET.
                    #TODO Fix this after merge. Missing modifications in New-ServerResponse
                    switch ($responseContentJson.result) {
                        ([Devolutions.RemoteDesktopManager.SaveResult]::NotFound) {
                            return [ServerResponse]::new($false, $response, $responseContentJson, $null, "Resource could not be found. Please make sure you are using an existing ID.", 404)
                        }
                        ( [Devolutions.RemoteDesktopManager.SaveResult]::Success.value__ ) { 
                            return [ServerResponse]::new($true , $response, $responseContentJson, $null, $null, 200) 
                        }
                        Default {
                        }
                    }
                }
                else {
                    if ($response.StatusCode -eq 201) {
                        return [ServerResponse]::new($true, $response, $responseContentJson, $null, $null, $response.StatusCode)
                    }
                    else {
                        return [ServerResponse]::new($false, $response, $responseContentJson, $null, "[POST] Unhandled error. If you see this, please contact your system administrator for help.", $response.StatusCode)
                    }
                }
            }
            "DELETE" {
                if (($null -ne $responseContentJson) -and ($HasResult)) {
                    #delete users, for exemple, returns "response.content.result", so we'll make use of that to detect errors and send back appropriate error message.
                    if ($responseContentJson.result -eq 1) {
                        return [ServerResponse]::new($true, $response, $responseContentJson, $null, $null, 200)
                    }
                    else {
                        return [ServerResponse]::new($false, $response, $responseContentJson, $null, $responseContentJson.errorMessage, 404)
                    }
                }
                elseif ($response.StatusCode -eq 204) {
                    #delete checkoutPolicy, for exemple, does NOT return "response.content.result". If code is 204, deletion was successful.
                    #TODO:Remove-DSPamProvider return a WebResponseObject, not a basic one....
#                    return [ServerResponse]::new($true, $null, $null, $null, $null, 204)
                    return [ServerResponse]::new($true, $null, $null, $null, $null, 204)
                }
                else {
                    #Any unhandled response will end here.
                    return [ServerResponse]::new($false, $null, $null, $null, "[DELETE] Unhandled error. If you see this, please contact your system administrator for help.", 500)
                }
            }
            "PUT" {
                if ($response.Content.Contains("duplicate")) {
                    return [ServerResponse]::new($false, $response, $responseContentJson, $null, "A user group with this name already exists. Please choose another name for your user group.", 400)
                }
                else {
                    return [ServerResponse]::new(($response.StatusCode -eq 200), $response, $responseContentJson, $null, "", $response.StatusCode)
                }
            }
            #Status 418: Should never get this response. If so, update switchcase so you don't.
            Default { return [ServerResponse]::new(($false), $response, $responseContentJson, $null, "Please contact your system administrator for help.", 418) }
        }
    }
}