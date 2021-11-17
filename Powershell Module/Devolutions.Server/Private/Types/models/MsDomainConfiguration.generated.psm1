using module '..\enums\ActiveDirectoryType.generated.psm1'
using module '..\enums\AdministrationLoginType.generated.psm1'
using module '..\enums\ContextType.psm1'
using module '..\enums\ContextOptions.psm1'
using module '..\enums\DomainUsernameFormatType.generated.psm1'
using module '..\enums\GetUsersStrategy.generated.psm1'
using module '..\enums\GetGroupsByUserStrategy.generated.psm1'
using module '..\enums\GetUsersByGroupStrategy.generated.psm1'
using module '..\enums\GetSubdomainsStrategy.generated.psm1'
using module '..\enums\UserValidityStrategy.generated.psm1'
using module '..\enums\GetGroupsStrategy.generated.psm1'

class MsDomainConfiguration {
	[guid]$Id
	[nullable[guid]]$ParentDomainId
	[String]$DomainNameNetBios
	[string[]]$DomainContainers
	[ValueResolver[ActiveDirectoryType]]$ActiveDirectoryType
	[ValueResolver[AdministrationLoginType]]$AdministrationLoginType
	[ValueResolver[boolean]]$IsLdaps
	[ValueResolver[int]]$LdapsCustomPort
	[ValueResolver[int]]$GlobalCatalogCustomPort
	[ValueResolver[boolean]]$IsGlobalCatalogSsl
	[ValueResolver[string]]$AdministrationUsername
	[ValueResolver[string]]$AdministrationPassword
	[String]$DisplayName
	[String]$DomainName
	[ContextType]$ContextType = [ContextType]::Domain
	[ContextOptions]$ContextOptions
	[String]$PreferredDomainController
	[ValueResolver[boolean]]$AutoCreateEnabled
	[ValueResolver[boolean]]$AutoCreateReadOnly
	[ValueResolver[DomainUsernameFormatType]]$AutoCreateUsernameFormatType
	[ValueResolver[string]]$AutoCreateVault
	[String]$AutoCreateGroupFilter
	[ValueResolver[GetGroupsStrategy]]$GetGroupsStrategy
	[ValueResolver[GetUsersStrategy]]$GetUsersStrategy
	[ValueResolver[GetGroupsByUserStrategy]]$GetGroupsByUserStrategy
	[ValueResolver[GetUsersByGroupStrategy]]$GetUsersByGroupStrategy
	[ValueResolver[GetSubdomainsStrategy]]$GetSubdomainsStrategy
	[ValueResolver[UserValidityStrategy]]$UserValidityStrategy
	[string[]]$Keys

	MsDomainConfiguration() {
		$this.Id = [guid]::NewGuid()
		$this.ParentDomainId = $null
		$this.DomainNameNetBios = ''
		$this.DomainContainers = @()
		$this.ActiveDirectoryType = [ValueResolver[ActiveDirectoryType]]::new([ActiveDirectoryType]::Microsoft)
		$this.AdministrationLoginType = [ValueResolver[AdministrationLoginType]]::new([AdministrationLoginType]::DomainUsernamePassword)
		$this.IsLdaps = [ValueResolver[boolean]]::new()
		$this.LdapsCustomPort = [ValueResolver[int]]::new()
		$this.GlobalCatalogCustomPort = [ValueResolver[int]]::new()
		$this.IsGlobalCatalogSsl = [ValueResolver[boolean]]::new()
		$this.AdministrationUsername = [ValueResolver[string]]::new()
		$this.AdministrationPassword = [ValueResolver[string]]::new()
		$this.DisplayName = ''
		$this.DomainName = ''
		#$this.ContextType = [ContextType]::Domain
		$this.ContextOptions = $this.IsLdaps.Get() ? ([ContextOptions]::Negotiate -bor [ContextOptions]::SecureSocketLayer) : ([ContextOptions]::Negotiate -bor [ContextOptions]::Signing -bor [ContextOptions]::Sealing)
		$this.PreferredDomainController = ''
		$this.AutoCreateEnabled = [ValueResolver[boolean]]::new()
		$this.AutoCreateReadOnly = [ValueResolver[boolean]]::new()
		$this.AutoCreateUsernameFormatType = [ValueResolver[DomainUsernameFormatType]]::new()
		$this.AutoCreateVault = [ValueResolver[string]]::new()
		$this.AutoCreateGroupFilter = ''
		$this.GetGroupsStrategy = [ValueResolver[GetGroupsStrategy]]::new([GetGroupsStrategy]::Default)
		$this.GetUsersStrategy = [ValueResolver[GetUsersStrategy]]::new([GetUsersStrategy]::Default)
		$this.GetGroupsByUserStrategy = [ValueResolver[GetGroupsByUserStrategy]]::new([GetGroupsByUserStrategy]::Default)
		$this.GetUsersByGroupStrategy = [ValueResolver[GetUsersByGroupStrategy]]::new([GetUsersByGroupStrategy]::Default)
		$this.GetSubdomainsStrategy = [ValueResolver[GetSubdomainsStrategy]]::new([GetSubdomainsStrategy]::Default)
		$this.UserValidityStrategy = [ValueResolver[UserValidityStrategy]]::new([UserValidityStrategy]::Default)
		$this.Keys = @()
	}
}
