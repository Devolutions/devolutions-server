function New-DSRDPEntry {
    [CmdletBinding()]
    PARAM (
        $ParamList
    )
    
    BEGIN {
        $URI = "$env:DS_URL/api/connections/partial/save"
    }
    
    PROCESS {
        $RDPEntry = @{
            connectionType = 1
            group          = $ParamList.Group
            data           = Protect-ResourceToHexString (
                ConvertTo-Json @{
                    host      = $ParamList.HostName 
                    adminMode = $ParamList.AdminMode
                    rdpType   = $ParamList.RDPType
                    username  = $ParamList.Username

                })
            name           = $ParamList.EntryName
        }

        if (![string]::IsNullOrWhiteSpace($ParamList.Username)) {
            
        }

        if (![string]::IsNullOrWhiteSpace($ParamList.Username)) {
            
        }

        $RequestParams = @{
            URI    = $URI
            Method = "POST"
            Body   = ConvertTo-Json $RDPEntry
        }

        $res = Invoke-DS @RequestParams -Verbose
        return $res
    }
    
    END {
        
    }
}