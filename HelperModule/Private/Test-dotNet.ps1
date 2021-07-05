function Test-dotNet {
    # Do nothing if .net 472 is already installed
    $vnet = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\'
    if (!($vnet.Release -ge 461814)) {
        return $true
    } else {
        return $false
        Write-LogEvent '.Net Framework is already installed'
    }
}