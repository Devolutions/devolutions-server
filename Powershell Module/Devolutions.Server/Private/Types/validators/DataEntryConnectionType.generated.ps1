using namespace System.Management.Automation

class DataEntryConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'Credential', 'CreditCard', 'Alarm', 'BankInfo', 'TravelInfo', 'Custom', 'AddOn', 'Serial', 'EmailAccount', 'SecureNote', 'Web', 'Passport', 'SafetyDeposit', 'Wallet', 'Wifi', 'ApplicationSendKey', 'DriverLicense', 'SocialSecurityNumber', 'Membership', 'DoorEntryCode', 'Cryptocurrency')
	}
}
