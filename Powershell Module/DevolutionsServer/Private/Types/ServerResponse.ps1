class ServerResponse {
    [bool] $isSuccess
    [Microsoft.PowerShell.Commands.WebResponseObject] $originalResponse
    [System.Exception] $Exception
    [string] $ErrorMessage
    [int] $StandardizedStatusCode  
    [PSCustomObject] $Body
    ServerResponse(
        [bool]$success,
        [Microsoft.PowerShell.Commands.WebResponseObject] $response = $null,
        [PSCustomObject] $Body = $null,
        [System.Exception] $exception = $null,
        [string] $errorMessage = "",
        [int] $statusCode = 200
    ) {
        $this.isSuccess = $success
        $this.originalResponse = $response
        $this.Body = $Body
        $this.Exception = $exception
        $this.ErrorMessage = $errorMessage
        $this.StandardizedStatusCode = $statusCode
    }
}
