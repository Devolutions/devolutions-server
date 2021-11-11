using module '..\models\ImportAnalyzeResult.generated.psm1'
using module '..\models\ImportParameter.generated.psm1'

class ImportDetailedParameters
{
	[ImportAnalyzeResult]$Analysis = [ImportAnalyzeResult]::new()
	[ImportParameter]$Parameters = [ImportParameter]::new()
}
