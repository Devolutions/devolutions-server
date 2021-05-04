function New-DSRDPEntry {
    <#
    .SYNOPSIS

    .DESCRIPTION

    .EXAMPLE
    #>
    [CmdletBinding()]
    PARAM (
        $ParamList
    )
    
    BEGIN {
        $URI = "$env:DS_URL/api/connections/partial/save"
    }
    
    PROCESS {
        try {
            #Default RDP entry, valid for all RDP type
            $RDPEntry = @{
                connectionType = 1
                group          = $ParamList.Folder
                name           = $ParamList.EntryName
                data           = @{
                    host      = $ParamList.HostName 
                    adminMode = $ParamList.AdminMode
                    rdpType   = $ParamList.RDPType
                    username  = $ParamList.Username
                }
            }

            #Create passwordItem if password is present and not null
            if (![string]::IsNullOrWhiteSpace($ParamList.Password)) {
                $RDPEntry.data += @{ 
                    "passwordItem" = @{ 
                        hasSensitiveData = $false
                        sensitiveData    = $ParamList.Password 
                    } 
                }
            }

            #Possible fields for RDP type "Azure"
            if ($ParamList.RDPType -eq [Devolutions.RemoteDesktopManager.RDPType]::Azure) {
                $RDPEntry.data += @{"azureInstanceID" = $ParamList.AzureInstanceID }
                $RDPEntry.data += @{"azureRoleName" = $ParamList.RoleName }
            }

            #Possible fields for RDP type "HyperV"
            if ($ParamList.RDPType -eq [Devolutions.RemoteDesktopManager.RDPType]::HyperV) {
                $RDPEntry.data += @{"hyperVInstanceID" = $ParamList.HyperVInstance }
                $RDPEntry.data += @{"useEnhancedSessionMode" = $ParamList.UseEnhancedSessionMode }
            }

            #Converts data to JSON, then encrypt the whole thing
            $RDPEntry.data = Protect-ResourceToHexString (ConvertTo-Json $RDPEntry.data)

            $RequestParams = @{
                URI    = $URI
                Method = "POST"
                Body   = ConvertTo-Json $RDPEntry
            }

            $res = Invoke-DS @RequestParams -Verbose
            return $res
        }
        catch {
            Write-Error $_.Exception.Message
        }
    }
    
    END {
        if ($res.isSuccess) {
            Write-Verbose "[New-DSRPDEntry] Completed successfully!"
        }
        else {
            Write-Verbose "[New-DSRPDEntry] Ended with errors..."
        }
    }
}