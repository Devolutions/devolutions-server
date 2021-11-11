using module '..\enums\ActiveDirectoryDomainType.generated.psm1'

class SynchronizerActiveDirectoryGeneral
{
	[ActiveDirectoryDomainType]$Mode = [ActiveDirectoryDomainType]::new()
	[boolean]$PingBeforeSynchronization = $false
	[String]$Domain = ''
	[String]$OrganizationalUnit = ''
	[boolean]$UseLdapOverSsl = $false
	[int]$LdapPort = 636
}
