using module '..\enums\DataEntryWalletType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class DataEntryWallet
{
	[String]$Url = ''
	[SensitiveItem]$DriverLicense = [SensitiveItem]::new()
	[SensitiveItem]$Membership = [SensitiveItem]::new()
	[SensitiveItem]$SocialSecurityNumber = [SensitiveItem]::new()
	[DataEntryWalletType]$WalletType = [DataEntryWalletType]::new()
}
