using module '..\enums\SecureNoteType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class DataEntrySecureNote
{
	[String]$EncryptedSecureNote = ''
	[boolean]$SecureNoteIsProtected = $false
	[SensitiveItem]$SecureNoteRtf = [SensitiveItem]::new()
	[SecureNoteType]$SecureNoteType = [SecureNoteType]::new()
	[String]$Url = ''
}
