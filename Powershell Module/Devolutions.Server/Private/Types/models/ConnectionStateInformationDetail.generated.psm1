using module '..\models\ConnectionStateInformation.generated.psm1'

class ConnectionStateInformationDetail : ConnectionStateInformation 
{
	[String]$Comment = ''
	[String]$CreationDate = $null
	[String]$CreationLoggedUserName = ''
	[String]$CreationUsername = ''
	[String]$RepositoryID = $null
}
