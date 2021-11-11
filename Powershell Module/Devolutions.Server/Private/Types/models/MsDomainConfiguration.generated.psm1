using module '..\enums\ContextOptions.generated.psm1'
using module '..\enums\ContextType.generated.psm1'
using module '..\models\IEnumerable`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'
using module '..\models\ValueResolver`1.generated.psm1'

class MsDomainConfiguration
{
	[String]$Id = $null
	[String]$ParentDomainId = $null
	[String]$DomainNameNetBios = ''
	[string[]]$DomainContainers = $null
	[ValueResolver<ActiveDirectoryType>]$ActiveDirectoryType = $null
	[ValueResolver<AdministrationLoginType>]$AdministrationLoginType = $null
	[ValueResolver<boolean>]$IsLdaps = $null
	[ValueResolver<number>]$LdapsCustomPort = $null
	[ValueResolver<number>]$GlobalCatalogCustomPort = $null
	[ValueResolver<boolean>]$IsGlobalCatalogSsl = $null
	[ValueResolver<string>]$AdministrationUsername = $null
	[String]$DisplayName = ''
	[String]$DomainName = ''
	[ContextType]$ContextType = [ContextType]::new()
	[ContextOptions]$ContextOptions = [ContextOptions]::new()
	[String]$PreferredDomainController = ''
	[ValueResolver<boolean>]$AutoCreateEnabled = $null
	[ValueResolver<boolean>]$AutoCreateReadOnly = $null
	[ValueResolver<DomainUsernameFormatType>]$AutoCreateUsernameFormatType = $null
	[ValueResolver<string>]$AutoCreateVault = $null
	[String]$AutoCreateGroupFilter = ''
	[ValueResolver<GetGroupsStrategy>]$GetGroupsStrategy = $null
	[ValueResolver<GetUsersStrategy>]$GetUsersStrategy = $null
	[ValueResolver<GetGroupsByUserStrategy>]$GetGroupsByUserStrategy = $null
	[ValueResolver<GetUsersByGroupStrategy>]$GetUsersByGroupStrategy = $null
	[ValueResolver<GetSubdomainsStrategy>]$GetSubdomainsStrategy = $null
	[ValueResolver<UserValidityStrategy>]$UserValidityStrategy = $null
	[string[]]$Keys = [string[]]::new()
}
