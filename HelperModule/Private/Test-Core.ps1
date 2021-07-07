function Test-Core {
    $regKey = 'hklm:/software/microsoft/windows nt/currentversion'
    $Core = (Get-ItemProperty $regKey).InstallationType
    if ($Core -eq 'Server Core') {
        return $true
        Write-LogEvent 'Confirmed this is a Server Core installation' -Output
    } else {
        return $false
        Write-LogEvent 'This is not a Server Core' -Output
    }
}