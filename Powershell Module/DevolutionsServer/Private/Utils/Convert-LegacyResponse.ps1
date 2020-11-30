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

            $responseContent = $Response.Content | ConvertFrom-Json

            if($responseContent.result -eq 1)
            {
                return [ServerResponse]::new($true, $Response, $responseContent, $null, "", 200)                        
            }

            $map = ""
            #BaseControllerV3.ToHttpStatusCode
            #No Result field means success
            $newStatusCode = 200
            if (!(Get-Member -inputobject $responseContent -name "result"))
            {
                return [ServerResponse]::new($true, $Response, $responseContent, $null, $null, $newStatusCode)                        
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