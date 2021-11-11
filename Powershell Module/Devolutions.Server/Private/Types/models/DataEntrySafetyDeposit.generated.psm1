using module '..\models\SensitiveItem.generated.psm1'

class DataEntrySafetyDeposit
{
	[String]$SafeDepositAddress = ''
	[String]$SafeDepositBoxNumberItem = ''
	[String]$SafeDepositCustomerServiceNumber = ''
	[String]$SafeDepositInstitution = ''
	[SensitiveItem]$SafeDepositPasscodeItem = [SensitiveItem]::new()
	[String]$Url = ''
}
