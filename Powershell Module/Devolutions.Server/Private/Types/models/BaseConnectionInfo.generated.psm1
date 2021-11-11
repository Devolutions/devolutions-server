using module '..\enums\ConnectionType.generated.psm1'
using module '..\enums\ContactConnectionType.generated.psm1'
using module '..\enums\CredentialResolverConnectionType.generated.psm1'
using module '..\enums\DataEntryConnectionType.generated.psm1'
using module '..\enums\DocumentConnectionType.generated.psm1'
using module '..\enums\GroupConnectionType.generated.psm1'
using module '..\enums\SessionToolConnectionType.generated.psm1'
using module '..\enums\SyncConnectionType.generated.psm1'
using module '..\enums\VPNApplication.generated.psm1'

class BaseConnectionInfo
{
	[ConnectionType]$ConnectionType = [ConnectionType]::new()
	[ContactConnectionType]$ContactType = [ContactConnectionType]::new()
	[CredentialResolverConnectionType]$CredentialType = [CredentialResolverConnectionType]::new()
	[DataEntryConnectionType]$DataEntryType = [DataEntryConnectionType]::new()
	[DocumentConnectionType]$DocumentType = [DocumentConnectionType]::new()
	[String]$Expiration = $null
	[String]$Group = ''
	[GroupConnectionType]$GroupType = [GroupConnectionType]::new()
	[String]$ID = ''
	[String]$Image = ''
	[String]$ImageName = ''
	[String]$MasterSubType = ''
	[String]$Name = ''
	[String]$Repository = '00000000-0000-0000-0000-000000000000'
	[SessionToolConnectionType]$SessionToolType = [SessionToolConnectionType]::new()
	[String]$SubType = ''
	[SyncConnectionType]$SyncType = [SyncConnectionType]::new()
	[VPNApplication]$VPNApplication = [VPNApplication]::new()
}
