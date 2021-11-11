using module '..\models\ConnectionInfoEntity.generated.psm1'
using module '..\models\RepositoryEntity.generated.psm1'

class ConnectionInfosEntity
{
	[ConnectionInfoEntity]$Connections = [ConnectionInfoEntity]::new()
	[String]$Version = ''
	[RepositoryEntity]$Repository = [RepositoryEntity]::new()
}
