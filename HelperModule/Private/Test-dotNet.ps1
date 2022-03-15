function Test-dotNet {
    # Do nothing if .net 4.8 is already installed
    $vnet = Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full\'
    if ((Test-Core) -and !($vnet.Release -ge 528049)) {
        return $true
    } elseif (!(Test-Core) -and !($vnet.Release -ge 528049)) {
        return $true
    } else {
        return $false
    }
}