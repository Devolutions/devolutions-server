using module '..\enums\ConnectionStringDataProviderType.generated.psm1'
using module '..\enums\ConnectionStringDataSourceType.generated.psm1'
using module '..\models\SensitiveItem.generated.psm1'

class CredentialConnectionString
{
	[SensitiveItem]$ConnectionString = [SensitiveItem]::new()
	[ConnectionStringDataProviderType]$DataProviderType = [ConnectionStringDataProviderType]::new()
	[ConnectionStringDataSourceType]$DataSourceType = [ConnectionStringDataSourceType]::new()
}
