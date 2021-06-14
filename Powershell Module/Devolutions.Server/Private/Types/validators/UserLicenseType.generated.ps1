using namespace System.Management.Automation

class UserLicenseTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Other', 'PasswordVaultManager', 'PasswordVaultManagerOnline', 'PasswordVaultManagerServer', 'RDMOCustomInstallerService', 'RDMOOnlineBackup', 'RemoteDesktopManager', 'RemoteDesktopManagerJump', 'RemoteDesktopManagerOnline', 'RemoteDesktopManagerOnlineBackup', 'RemoteDesktopManagerServer', 'PasswordVaultManagerFree', 'RemoteDesktopManagerFree', 'Wayk')
	}
}
