using module '..\models\BaseConnection.generated.psm1'
using module '..\enums\DocumentConnectionType.generated.psm1'
using module '..\enums\DocumentDataMode.generated.psm1'
using module '..\enums\PDFViewerType.generated.psm1'

class DocumentConnection : BaseConnection 
{
	[String]$TextDocumentFormat = ''
	[boolean]$AllowExport = $true
	[boolean]$AllowExportForEveryone = $false
	[boolean]$AllowPreview = $true
	[String]$ConnectionSubType = ''
	[String]$Data = ''
	[DocumentDataMode]$DocumentDataMode = [DocumentDataMode]::new()
	[DocumentConnectionType]$DocumentType = [DocumentConnectionType]::new()
	[String]$EmbeddedData = ''
	[String]$EmbeddedDataID = ''
	[String]$Filename = ''
	[String]$Password = ''
	[PDFViewerType]$PDFViewer = [PDFViewerType]::new()
	[String]$Program = ''
	[boolean]$ReadOnly = $true
	[boolean]$Run64BitsMode = $false
	[boolean]$EditOnOpen = $false
	[String]$Title = ''
	[boolean]$RunAsAdministrator = $false
	[String]$SafePassword = ''
	[int]$Size = 0
	[boolean]$UseDefaultWorkingDirectory = $true
	[boolean]$UseShellExecute = $true
	[boolean]$UseWebDefaultCredentials = $false
	[String]$WorkingDirectory = ''
}
