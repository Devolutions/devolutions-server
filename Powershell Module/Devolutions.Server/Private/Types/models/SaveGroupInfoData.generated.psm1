using module '..\models\GroupInfoEntity.generated.psm1'

class SaveGroupInfoData
{
	[GroupInfoEntity]$GroupInfo = [GroupInfoEntity]::new()
	[String]$OldName = ''
}
