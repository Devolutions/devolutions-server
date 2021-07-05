# function Get-DSEntriesModern {
#     <#
#     .SYNOPSIS
    
#     .DESCRIPTION
    
#     .EXAMPLE
    
#     .NOTES
    
#     .LINK
#     #>
#     [CmdletBinding()]
#     param(			     
#     )
        
#     BEGIN {
#         Write-Verbose '[Get-DSEntry] Beginning...'

#         if ([string]::IsNullOrWhiteSpace($Global:DSSessionToken)) {
#             throw "Session does not seem authenticated, call New-DSSession."
#         }
#     }
    
#     PROCESS {
#         $params = @{
#             URI    = "http://localhost/dps/api/v3/entries?vaultId=$([guid]::Empty)&folderId=c54dde7a-f8d4-4ba5-8281-7bec11a28b24"
#             Method = "GET"
#         }
        
#         $res = Invoke-DS @params
#         return $res
#     }
    
#     END {
#         If ($res.isSuccess) {
#             Write-Verbose '[Get-DSEntry] Completed Successfully.'
#         }
#         else {
#             Write-Verbose '[Get-DSEntry] ended with errors...'
#         }
#     }
# }