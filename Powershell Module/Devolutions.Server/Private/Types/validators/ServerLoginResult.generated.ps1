using namespace System.Management.Automation

class ServerLoginResultValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Error', 'Success', 'InvalidUserNamePassword', 'InvalidDataSource', 'DisabledDataSource', 'InvalidSubscription', 'TooManyUserForTheLicense', 'ExpiredSubscription', 'InGracePeriod', 'DisabledUser', 'UserNotFound', 'LockedUser', 'NotApprovedUser', 'BlackListed', 'InvalidIP', 'UnableToCreateUser', 'TwoFactorTypeNotConfigured', 'TwoFactorTypeActivatedNotAllowedClientSide', 'DomainNotTrusted', 'UserDoesNotBelongToDefaultDomain', 'InvalidGeoIP', 'TwoFactorIsRequired', 'TwoFactorPreconfigured', 'TwoFactorSecondStepIsRequired', 'TwoFactorUserIsDenied', 'TwoFactorSmsSended', 'TwoFactorTimeout', 'TwoFactorUserLockedOut', 'TwoFactorUserFraud', 'TwoFactorUserEmailNotConfigured', 'TwoFactorUserSmsNotConfigured', 'NotInTrustedGroup', 'ServerNotResponding', 'NotAccessToApplication', 'DirectoryNotResponding', 'WindowsAuthenticationFailure', 'ForcePasswordChange', 'TwoFactorInvalid', 'OutsideValidUsageTimePeriod')
	}
}
