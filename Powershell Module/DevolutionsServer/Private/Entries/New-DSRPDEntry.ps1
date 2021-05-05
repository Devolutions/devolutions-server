function New-DSRDPEntry {
    <#
    .SYNOPSIS
    Creates a new RDP entry
    .DESCRIPTION
    Creates a new RDP entry with the parameters supplied. All fields have a default value corresponding to those of Remote Desktop Manager.
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
                connectionType        = 1
                group                 = $ParamList.Folder
                name                  = $ParamList.EntryName
                displayMode           = $ParamList.DisplayMode
                DisplayMonitor        = $ParamList.DisplayMonitor
                displayVirtualDesktop = $ParamList.DisplayVirtualDesktop
                data                  = @{
                    host                        = $ParamList.HostName 
                    adminMode                   = $ParamList.AdminMode
                    rdpType                     = $ParamList.RDPType
                    username                    = $ParamList.Username
                    soundHook                   = $ParamList.SoundHook
                    audioQualityMode            = $ParamList.AudioQualityMode
                    usesClipboard               = $ParamList.UsesClipboard
                    usesDevices                 = $ParamList.UsesDevices
                    usesHardDrives              = $ParamList.UsesHardDrives
                    usesPrinters                = $ParamList.UsesPrinters
                    usesSerialPorts             = $ParamList.UsesSerialPorts
                    usesSmartDevices            = $ParamList.UsesSmartDevices     
                    audioCaptureRedirectionMode = $ParamList.AudioCaptureRedirectionMode
                    connectionType              = $ParamList.NetworkConnectionType
                    videoPlaybackMode           = $ParamList.RedirectVideoPlayback
                    loadAddOnsMode              = switch ($ParamList.LoadAddonsMode) {
                        "Default" { 1; break }
                        "Yes" { 2 ; break }
                        "No" { 3 ; break }
                    }
                    keyboardHook                = $ParamList.KeyboardHook
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
                $RDPEntry.data += @{ "azureInstanceID" = $ParamList.AzureInstanceID }
                $RDPEntry.data += @{ "azureRoleName" = $ParamList.RoleName }
            }

            #Possible fields for RDP type "HyperV"
            if ($ParamList.RDPType -eq [Devolutions.RemoteDesktopManager.RDPType]::HyperV) {
                $RDPEntry.data += @{ "hyperVInstanceID" = $ParamList.HyperVInstance }
                $RDPEntry.data += @{ "useEnhancedSessionMode" = $ParamList.UseEnhancedSessionMode }
            }

            #After login program
            if (![string]::IsNullOrEmpty($ParamList.AfterLoginProgram)) {
                $RDPEntry.data += @{ "afterLoginExecuteProgram" = $true }
                $RDPEntry.data += @{ "afterLoginProgram" = $ParamList.AfterLoginProgram }
                $RDPEntry.data += @{
                    "afterLoginDelay" = switch ($ParamList.AfterLoginDelay) {
                        { $_ -lt 0 } { 0 }
                        { $_ -lt 60000 } { 60000 }
                        Default { $ParamList.AfterLoginDelay }
                    }
                }
            }

            #Alternate shell/RemoteApp program. Prioritizing RemoteApp, as it's preferred over alternative shell
            if (![string]::IsNullOrEmpty($ParamList.RemoteApplicationProgram)) {
                $RDPEntry.data += @{ "remoteApp" = $true }
                $RDPEntry.data += @{ "remoteApplicationProgram" = $ParamList.RemoteApplicationProgram }
                $RDPEntry.data += @{ "remoteApplicationCmdLine" = $ParamList.RemoteApplicationCmdLine }
            }
            elseif (![string]::IsNullOrEmpty($ParamList.AlternateShell)) {
                $RDPEntry.data += @{ "useAlternateShell" = $true }
                $RDPEntry.data += @{ "alternateShell" = $ParamList.AlternateShell }
                $RDPEntry.data += @{ "shellWorkingDirectory" = $ParamList.ShellWorkingDirectory }
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