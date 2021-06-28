enum LoginAttemptFailType
{
    Error = 0
    UserName = 1
    Password = 2
    UserNamePassword = 3
    Expired = 4
    Locked = 5
    Disabled = 6
    InvalidIP = 7
    InvalidDataSource = 8
    DisabledDataSource = 9
    InvalidSubscription = 10
    TooManyUserForTheLicense = 11
    NotApproved = 12
    BlackListed = 13
    Success = 14
    UnableToCreateUser = 15
    TwoFactorFailed = 16
    TwoFactorUserIsDenied = 17
    TwoFactorSecondStepIsRequired = 18
    TwoFactorTimeout = 19
    TwoFactorUserFraud = 20
    TwoFactorUserLockedOut = 21
    TwoFactorSmsSended = 22
    TwoFactorUserEmailNotConfigured = 23
    TwoFactorUserSmsNotConfigured = 24
    NotAccessToApplication = 25
    FailedGeoIpPValidation = 26
    TwoFactorInvalid = 27
    NotInTrustedGroup = 28
    TwoFactorNotConfigured = 29
    OutsideValidUsageTimePeriod = 30
}
