using module '..\models\AnalyzeRdmFileParameters.generated.psm1'
using module '..\enums\ImportContentType.generated.psm1'
using module '..\enums\XmlTransferType.generated.psm1'

class AnalyzeKeyPassFileParameters : AnalyzeRdmFileParameters 
{
	[ImportContentType]$ContentFormat = [ImportContentType]::new()
	[XmlTransferType]$ImportType = [XmlTransferType]::new()
}
