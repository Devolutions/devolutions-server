function Test-Network {
    Write-LogEvent 'Testing network connectivity' -Output
    $ping = Test-NetConnection -Hops 2 -WarningAction SilentlyContinue
    Write-LogEvent "$env:COMPUTERNAME has internet access" -Output
    return $ping.PingSucceeded
}