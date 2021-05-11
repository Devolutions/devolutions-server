Function Convert-LegacyResponse {
    <#
    .SYNOPSIS
    .DESCRIPTION
    .PARAMETER 
    .NOTES
    #>
        [cmdletbinding()]
        [OutputType([ServerResponse])]
        param(
            [Microsoft.PowerShell.Commands.BasicHtmlWebResponseObject] $Response
        )

<#
  RDM expected to always get HTTP 200, but analyzed the result field.  During the transition to 
  modern endpoints we need to map 
 #>
        BEGIN{

        }

        PROCESS{
            if ($Response -eq $null)
            {
                return [ServerResponse]::new($false, $null, $null, $exc, "", 400)                        
            }

            $responseContentHash = $Response.Content | ConvertFrom-Json -AsHashtable
            $responseContent = $Response.Content | ConvertFrom-Json

            #some legacy apis return only result=1...
            if (($responseContentHash.Keys.Count -eq 1) -and ($responseContentHash.ContainsKey('result'))) {
                $newbody = $null
            } else {
                # some others return arrays of objects without ceremony
                if ($responseContent -is [system.array]) {
                    $newdata = $responseContent
                } elseif ($responseContent -is [Boolean]) {
                    $newdata = $responseContent
                }
                elseif ($responseContentHash.ContainsKey('data')) {
                    $newdata = $responseContent.data
                } else {
                    throw "unexpected condition in Convert-LegacyResponse"
                }

                #for standardization, we must push it down to a Body.data element
                $newbody = [PSCustomObject]@{
                    totalCount = -1
                    currentPage = -1
                    data = $newdata
                }
            }

            if($responseContent.result -eq 1)
            {
                return [ServerResponse]::new($true, $Response, $newbody, $null, "", 200)                        
            }

            $map = ""
            #BaseControllerV3.ToHttpStatusCode
            #Absent Result field means success (assume 1 when null...)
            $newStatusCode = 200
            if (!(Get-Member -inputobject $responseContent -name "result"))
            {
                return [ServerResponse]::new($true, $Response, $newbody, $null, $null, $newStatusCode)                        
            }

            switch ($responseContent.result) {
                2 {
                    $map = "AccessDenied"
                    $newStatusCode = 401
                }
                3 {
                    $map = "InvalidData"
                    $newStatusCode = 400
                }
                4 {
                    $map = "AlreadyExists"
                    $newStatusCode = 400
                }
                5 {
                    $map = "MaximumReached"
                    $newStatusCode = 400
                }
                6 {
                    $map = "NotFound"
                    $newStatusCode = 404
                }
                7 {
                    $map = "LicenseExpired"
                    $newStatusCode = 401
                }
                8 {
                    $map = "Unknown"
                    $newStatusCode = 500
                }
                9 {
                    $map = "TwoFactorTypeNotConfigured"
                    $newStatusCode = 401
                }
                10 {
                    $map = "WebApiRedirectToLogin"
                    $newStatusCode = 401
                }
                11 {
                    $map = "DuplicateLoginEmail"
                    $newStatusCode = 400
                }
            }
            return [ServerResponse]::new($false, $Response, $responseContent, $null, $responseContent.errorMessage, $newStatusCode)                        
        }

        END{

        }

}