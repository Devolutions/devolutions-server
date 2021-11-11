using module '..\models\SensitiveItem.generated.psm1'

class DataEntryBankInfo
{
	[String]$BankAccountAddress = ''
	[String]$BankAccountOwner = ''
	[String]$BankAccountNumber = ''
	[String]$BankAccountType = ''
	[String]$BankBranch = ''
	[String]$BankContact = ''
	[String]$BankName = ''
	[String]$BankPhone = ''
	[SensitiveItem]$BankPin = [SensitiveItem]::new()
	[String]$BankRoutingNumber = ''
	[String]$BankSWIFT = ''
	[String]$Url = ''
}
