# Devolutions Server PowerShell Module
Interact with Devolutions Server instances using PowerShell Core, making it possible to run scripts from all the platforms that are supported by the framework.
# Requirements
* .Net Standard
* PowerShell Core
# Samples
Please consult the provided samples in the ./Samples folder, we will keep adding scripts for common workflows
# A note on encryption
Because of the long history of Remote Desktop Manager, paired with Devolutions Server, as well as some customers wanting to keep the deployment as simple as possible, the server was designed with an additional layer of encryption that did not rely on SSL/TLS. Our login process is therefore a little more involved then other PS modules in the *Privileged Access Management* space, but we feel that the complexity is well hidden in our cmdlets.
# A note on the cmdlets results
The server offers a few hundred endpoints that conform with varying levels of conformance with today's REST API best practices.  Since adapting endpoints is still a work in progress, our cmdlets return a standardized structure in order to isolate you from having to know the particulars of each endpoint.

The model is
```Powershell
class ServerResponse {
    [bool] $isSuccess
    [Microsoft.PowerShell.Commands.WebResponseObject] $originalResponse
    [System.Exception] $Exception
    [string] $ErrorMessage
    [int] $StandardizedStatusCode  
    [PSCustomObject] $Body
}    
```
Our aim is for you to have to check IsSuccess, then access the Body.

The Body's model is
```Powershell
class Body {
    [int] currentPage
    [int] pageSize
    [int] totalCount
    [int] totalPage
    [array] data
}
```
This means that $results.Body.data[0] contains the first row of the result set.
# Usage
## Authentication
New-DSSession is used to establish a session with your Devolutions Server instance.
```powershell
New-DSSession -Credential $cred -BaseURI https://dvls.yourdomain.com
```
## Basic operations
### Vaults
#### Fetching the list of vaults

Get-DSVaults
```powershell
> $results = Get-DSVaults
> $results.Body.data

id                                   name
--                                   ----
00000000-0000-0000-0000-000000000000 Default
7c1d192a-5d81-4fd5-8dfb-57309afe17b1 Power
0a075561-0245-4e70-a08f-26511f1464f2 Shell
```
### Entries
#### Fetching all of the entries from a vault

Get-DSEntries
>  tip : the "Default" vault has all zeros has an identifier, this can be shortened to ([guid]::Empty)

```powershell
> $results = Get-DSEntries -VaultId ([guid]::Empty)
> $results.Body.Data.count
49
> $results.Body.Data[0]
splittedGroupMain : {Powershell}
connectionType    : 25
name              : Powershell rules
id                : 9b6c544b-eb46-4fc4-b59d-001a4f9d7f92
repositoryID      : 00000000-0000-0000-0000-000000000000
...
```
#### Getting a single entry

Get-DSEntry
```powershell
> $entry = Get-DSEntry -EntryId  9b6c544b-eb46-4fc4-b59d-001a4f9d7f92
> $entry.Body.data
splittedGroupMain : {Powershell}
connectionType    : 25
name              : Powershell rules
id                : 9b6c544b-eb46-4fc4-b59d-001a4f9d7f92
repositoryID      : 00000000-0000-0000-0000-000000000000
...
```
#### Getting the password from an entry
Get-DSEntrySensitiveData
```powershell
> $entry = Get-DSEntrySensitiveData 9b6c544b-eb46-4fc4-b59d-001a4f9d7f92
> $sensitive.Body.data.credentials

password  userName
--------  --------
Pa$$w0rd! root
```

