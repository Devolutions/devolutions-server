using module '..\models\SensitiveItem.generated.psm1'

class DataEntryCreditCard
{
	[String]$CreditCardCustomerServicePhone = ''
	[SensitiveItem]$CreditCardExpirationMonth = [SensitiveItem]::new()
	[SensitiveItem]$CreditCardExpirationYear = [SensitiveItem]::new()
	[boolean]$CreditCardHideSensitive = $false
	[String]$CreditCardInternationalServicePhone = ''
	[String]$CreditCardIssuingBank = ''
	[SensitiveItem]$CreditCardNumber = [SensitiveItem]::new()
	[String]$CreditCardOwner = ''
	[SensitiveItem]$CreditCardPassword = [SensitiveItem]::new()
	[SensitiveItem]$CreditCardPin = [SensitiveItem]::new()
	[SensitiveItem]$CreditCardSecureCode = [SensitiveItem]::new()
	[SensitiveItem]$CreditCardSecurity = [SensitiveItem]::new()
	[String]$CreditCardType = ''
	[SensitiveItem]$CreditCardValidFromMonth = [SensitiveItem]::new()
	[SensitiveItem]$CreditCardValidFromYear = [SensitiveItem]::new()
	[SensitiveItem]$CreditCardVerifiedBy = [SensitiveItem]::new()
	[String]$Url = ''
}
