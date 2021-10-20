function Test-Core {
    $regKey = 'hklm:/software/microsoft/windows nt/currentversion'
    $Core = (Get-ItemProperty $regKey).InstallationType
    if ($Core -eq 'Server Core') {
        return $true
        Write-LogEvent "$Core machine" -Output
    } else {
        return $false
        Write-LogEvent 'This is not a Server Core machine' -Output
    }
}