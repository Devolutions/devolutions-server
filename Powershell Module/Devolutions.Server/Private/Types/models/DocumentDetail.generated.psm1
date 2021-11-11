using module '..\enums\DocumentConnectionType.generated.psm1'
using module '..\enums\DocumentDataMode.generated.psm1'

class DocumentDetail
{
	[boolean]$FileExist = $true
	[String]$CreatedBy = ''
	[String]$CreationDate = ''
	[DocumentDataMode]$DataMode = [DocumentDataMode]::new()
	[int]$DocumentSize = 0
	[String]$FileName = ''
	[DocumentConnectionType]$Type = [DocumentConnectionType]::new()
	[boolean]$UseWebDefaultCredentials = $false
}
