function Test-Network {
    $ping = Test-NetConnection -Hops 2 -WarningAction SilentlyContinue
    return $ping.PingSucceeded
}