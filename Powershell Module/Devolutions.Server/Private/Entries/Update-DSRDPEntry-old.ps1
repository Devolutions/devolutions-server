function Update-DSRDPEntry-old {
    [CmdletBinding()]
    PARAM (
        $ParamList
    )
    
    BEGIN {
        Write-Verbose "[Update-DSRDPEntry] Beginning..."

        if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
            throw "Session does not seem authenticated, call New-DSSession."
        }
    }
    
    PROCESS {
        try {
            $IgnoredParams = @('WarningAction', 'Verbose', 'CandidEntryID', 'Debug', 'PrivateKeyPath', 'PrivateKeyPassphrase', 'Domain', 'OutBuffer', 'OutVariable', 'ErrorVariable', 'InformationAction', 'ErrorAction', 'InformationVariable', 'WarningVariable', 'PipelineVariable')
            $PartialConnectionRoot = @('Folder', 'EntryName')
            $EntryResolvedVariables = (Get-DSEntry -EntryId $CandidEntryID -IncludeAdvancedProperties).Body.data

            foreach ($param in $ParamList.GetEnumerator()) {
                #Skip param if empty or null
                if (($null -ne $param.Value) -and ![string]::IsNullOrWhiteSpace($param.Value)) {
                    #If param is in object's root
                    if (($param.Key -in $EntryResolvedVariables.PSObject.Properties.Name) -or ($param.Key -in $PartialConnectionRoot)) {
                        #Handle Folder(group) and EntryName(name), then update value if param exists or add new member to object's root
                        switch ($param.Key) {
                            'Folder' { $EntryResolvedVariables.group = $param.Value; break }
                            'EntryName' { $EntryResolvedVariables.name = $param.Value ; break }
                            Default {
                                if ($param.Key -in $EntryResolvedVariables.PSObject.Properties.Name) {
                                    $EntryResolvedVariables.($param.Key) = $param.Value
                                }
                                else {
                                    $EntryResolvedVariables | Add-Member -NotePropertyName $param.Key -NotePropertyValue $param.Value
                                }
                            }
                        }
                    }
                    #If param is in object.data
                    else {
                        #If param should be ignored, such as 'Verbose'
                        if ($param.Key -ne $IgnoredParams) {
                            switch ($param.Key) {
                                'Password' {
                                    $EntryResolvedVariables.data.passwordItem = @{
                                        hasSensitiveData = $true
                                        sensitiveData    = $param.Value
                                    } 
                                    break
                                }

                                'HostName' {
                                    $EntryResolvedVariables.data.host = $param.Value
                                    break 
                                }

                                { $_ -in @('RemoteApplicationProgram', 'AlternateShell') } { 
                                    if (![string]::IsNullOrEmpty($ParamList.RemoteApplicationProgram)) {
                                        $EntryResolvedVariables.data | Add-Member -NotePropertyName 'remoteApp' -NotePropertyValue $true -Force
                                        $EntryResolvedVariables.data | Add-Member -NotePropertyName 'remoteApplicationProgram' -NotePropertyValue $ParamList.RemoteApplicationProgram -Force
                                        $EntryResolvedVariables.data | Add-Member -NotePropertyName 'remoteApplicationCmdLine' -NotePropertyValue $ParamList.RemoteApplicationCmdLine -Force
                                    }
                                    elseif (![string]::IsNullOrEmpty($ParamList.AlternateShell)) {
                                        $EntryResolvedVariables.data | Add-Member -NotePropertyName 'useAlternateShell' -NotePropertyValue $true -Force
                                        $EntryResolvedVariables.data | Add-Member -NotePropertyName 'alternateShell' -NotePropertyValue $ParamList.AlternateShell -Force
                                        $EntryResolvedVariables.data | Add-Member -NotePropertyName 'shellWorkingDirectory' -NotePropertyValue $ShellWorkingDirectory -Force
                                    }
                                    break;
                                }

                                'AfterLoginProgram' {
                                    $AfterLoginDelay = switch ($ParamList.AfterLoginDelay) {
                                        $null { 500 }
                                        ($_ -le 0) { 0 }
                                        ($_ -ge 60000) { 60000 }
                                    }
                                    $EntryResolvedVariables.data | Add-Member -NotePropertyName "afterLoginExecuteProgram" -NotePropertyValue $true -Force
                                    $EntryResolvedVariables.data | Add-Member -NotePropertyName "afterLoginProgram" -NotePropertyValue $ParamList.AfterLoginProgram -Force
                                    $EntryResolvedVariables.data | Add-Member -NotePropertyName "afterLoginDelay" -NotePropertyValue $AfterLoginDelay -Force
                                    
                                    break
                                }   

                                Default {
                                    if ($param.Key -in $EntryResolvedVariables.data.PSObject.Properties.Name) {
                                        $EntryResolvedVariables.data.($param.Key) = $param.Value
                                    }
                                    else {
                                        $EntryResolvedVariables.data | Add-Member -NotePropertyName $param.Key -NotePropertyValue $param.Value
                                    }
                                }
                            }
                        }
                    }
                }
            }

            $EntryResolvedVariables.data = Protect-ResourceToHexString (ConvertTo-Json $EntryResolvedVariables.data)

            $RequestParams = @{
                Uri    = "$Script:DSBaseURI/api/connections/partial/save"
                Method = "PUT"
                Body   = ConvertTo-Json ($EntryResolvedVariables)
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
            Write-Verbose "[Update-DSRDPEntry] Completed successfully!"
        }
        else {
            Write-Verbose "[Update-DSRDPEntry] Ended with errors..."
        }
    }
}