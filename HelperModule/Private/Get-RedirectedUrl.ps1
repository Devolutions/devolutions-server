Function Get-RedirectedUrl {
    Param (
        [Parameter(Mandatory = $true)]
        [String]$Url
    )

    $request = [System.Net.WebRequest]::Create($Url)
    $request.AllowAutoRedirect = $true

    try {
        $response = $request.GetResponse()
        $response.ResponseUri.AbsoluteUri
        $response.Close()
    } catch [System.Exception] { Write-LogEvent $_ -Errors }
}