using module '..\enums\PasswordQualityEstimator.generated.psm1'

class PasswordAnalyzeInfo
{
	[String]$ConnectionId = $null
	[String]$Date = $null
	[String]$Description = ''
	[String]$ExpireDate = $null
	[String]$Group = ''
	[String]$HostVpn = ''
	[boolean]$IsPasswordEmpty = $null
	[boolean]$IsPasswordVpnEmpty = $null
	[boolean]$IsPrivate = $null
	[String]$Name = ''
	[int]$Occurance = $null
	[PasswordQualityEstimator]$PasswordStrengthValue = [PasswordQualityEstimator]::new()
	[PasswordQualityEstimator]$PasswordStrengthVpnValue = [PasswordQualityEstimator]::new()
	[String]$UserName = ''
}
