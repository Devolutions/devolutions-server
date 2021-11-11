using module '..\models\AnalyzeKeyPassFileParameters.generated.psm1'
using module '..\models\ImportDetailedParameters.generated.psm1'
using module '..\models\ImportParameter.generated.psm1'

class ImportRdmFileParameters : AnalyzeKeyPassFileParameters 
{
	[ImportDetailedParameters]$DetailedParameters = [ImportDetailedParameters]::new()
	[ImportParameter]$GlobalParameters = [ImportParameter]::new()
}
