using namespace System.Management.Automation

class LoginAttemptFailTypeValidator : IValidateSetValuesGenerator {
	[string[]]GetValidValues() {
		return ('Error', 'UserName', 'Password', 'UserNamePassword', 'Expired', 'Locked', 'Disabled', 'InvalidIP', 'InvalidDataSource', 'DisabledDataSource', 'InvalidSubscription', 'TooManyUserForTheLicense', 'NotApproved', 'BlackListed', 'Success', 'UnableToCreateUser', 'TwoFactorFailed', 'TwoFactorUserIsDenied', 'TwoFactorSecondStepIsRequired', 'TwoFactorTimeout', 'TwoFactorUserFraud', 'TwoFactorUserLockedOut', 'TwoFactorSmsSended', 'TwoFactorUserEmailNotConfigured', 'TwoFactorUserSmsNotConfigured', 'NotAccessToApplication', 'FailedGeoIpPValidation', 'TwoFactorInvalid', 'NotInTrustedGroup', 'TwoFactorNotConfigured', 'OutsideValidUsageTimePeriod')
	}
}
