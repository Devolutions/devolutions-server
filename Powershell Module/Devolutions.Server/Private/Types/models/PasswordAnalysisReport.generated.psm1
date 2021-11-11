using module '..\models\PasswordAnalyzeInfo.generated.psm1'

class PasswordAnalysisReport
{
	[PasswordAnalyzeInfo]$CredentialData = [PasswordAnalyzeInfo]::new()
	[PasswordAnalyzeInfo]$DataEntryData = [PasswordAnalyzeInfo]::new()
	[PasswordAnalyzeInfo]$SessionData = [PasswordAnalyzeInfo]::new()
}
