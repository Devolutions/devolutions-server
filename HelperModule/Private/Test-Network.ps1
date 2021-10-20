function Test-Network {
    Test-NetConnection -InformationLevel Quiet -Hops 3 -WarningAction SilentlyContinue
}