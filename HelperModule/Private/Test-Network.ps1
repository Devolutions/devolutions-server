function Test-Network {
    Write-LogEvent 'Testing network connectivity...'
    $ping = Test-NetConnection -Hops 2 -WarningAction SilentlyContinue
    if ($ping.PingSucceeded) { Write-LogEvent "$env:COMPUTERNAME has internet access." }
    else { Write-LogEvent "$env:COMPUTERNAME has no internet access." -Errors }
    return $ping.PingSucceeded
}