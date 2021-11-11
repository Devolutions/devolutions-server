using module '..\enums\PartialConnectionCredentialsStatus.generated.psm1'

class PartialConnectionCredentials
{
	[String]$Domain = ''
	[String]$Password = ''
	[PartialConnectionCredentialsStatus]$Status = [PartialConnectionCredentialsStatus]::new()
	[String]$UserName = ''
}
