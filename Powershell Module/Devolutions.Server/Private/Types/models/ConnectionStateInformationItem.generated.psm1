using module '..\models\ConnectionStateInformation.generated.psm1'

class ConnectionStateInformationItem : ConnectionStateInformation 
{
	[String]$ConnectionName = ''
	[String]$Group = ''
	[String]$User = ''
}
