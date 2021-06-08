using namespace System.Management.Automation

class CredentialResolverConnectionTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Default', 'KeePass', 'LastPass', 'PasswordSafe', 'OnePassword', 'RoboForm', 'ChromePasswordManager', 'FirefoxPasswordManager', 'WindowsVault', 'PasswordVaultManager', 'AddOn', 'SecretServer', 'DataVault', 'ConnectionString', 'PrivateKey', 'Passwordstate', 'PleasantPasswordServer', 'AuthAnvilPasswordServer', 'ManagedEngine', 'AppleKeychain', 'CyberArk', 'PMPro', 'DPS', 'PasswordBox', 'PassPortal', 'OTP', 'OneTimeCodeList', 'Custom', 'LAPS', 'Dashlane', 'TeamPass', 'TrueKey', 'StickyPassword', 'Hub', 'OnePasswordTeam', 'ZohoPassword', 'BeyondTrustPasswordSafe', 'SecurityPattern', 'CyberArkAim', 'PasswordList', 'TPAM', 'Centrify', 'Bitwarden', 'MatesoPasswordSafe', 'HashiCorpVault', 'KeeperEnterprise', 'DpsPam', 'AzureKeyVault', 'ApplicationPassword', 'ApiKey', 'RSASecurID', 'TopicusKeyHub', 'ITGlue', 'KasperskyPasswordManager', 'AzureServicePrincipal', 'PsonoPasswordManager')
	}
}
