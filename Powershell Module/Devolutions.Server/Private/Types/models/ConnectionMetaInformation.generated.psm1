using module '..\models\BaseConnection.generated.psm1'
using module '..\enums\ContactConnectionType.generated.psm1'
using module '..\enums\ContactMode.generated.psm1'
using module '..\models\CustomFieldEntity.generated.psm1'
using module '..\enums\DefaultBoolean.generated.psm1'
using module '..\enums\Gender.generated.psm1'
using module '..\enums\HyperVVersion.generated.psm1'
using module '..\models\RecoveryCodeItem.generated.psm1'
using module '..\enums\VendorMode.generated.psm1'

class ConnectionMetaInformation : BaseConnection 
{
	[String]$Address = ''
	[int]$AgentConnectionTimeOut = -1
	[DefaultBoolean]$AllowMultipleConnections = [DefaultBoolean]::new()
	[String]$Architecture = ''
	[String]$AssetTag = ''
	[String]$AssociatedEmail = ''
	[String]$BirthdayDateTimeString = ''
	[String]$Blade = ''
	[String]$BladeDetails = ''
	[String]$Cell = ''
	[String]$City = ''
	[String]$Company = ''
	[String]$ConnectionSubType = ''
	[String]$ContactDomain = ''
	[String]$ContactLinkID = ''
	[String]$ContactLinkUsername = ''
	[ContactMode]$ContactMode = [ContactMode]::new()
	[ContactConnectionType]$ContactType = [ContactConnectionType]::new()
	[String]$ContactUsername = ''
	[String]$Country = ''
	[String]$Cpu = ''
	[int]$CPUCoreCount = 0
	[String]$CustomerNumber = ''
	[String]$CustomerNumberLabel = ''
	[boolean]$CustomField1Hidden = $false
	[String]$CustomField1Title = ''
	[String]$CustomField1Value = ''
	[boolean]$CustomField2Hidden = $false
	[String]$CustomField2Title = ''
	[String]$CustomField2Value = ''
	[boolean]$CustomField3Hidden = $false
	[String]$CustomField3Title = ''
	[String]$CustomField3Value = ''
	[boolean]$CustomField4Hidden = $false
	[String]$CustomField4Title = ''
	[String]$CustomField4Value = ''
	[boolean]$CustomField5Hidden = $false
	[String]$CustomField5Title = ''
	[String]$CustomField5Value = ''
	[CustomFieldEntity]$CustomFieldEntities = [CustomFieldEntity]::new()
	[string[]]$CustomServerFeatureRoles = [string[]]::new()
	[String]$Domain = ''
	[String]$Drives = ''
	[String]$Email = ''
	[String]$Expiration = $null
	[String]$Fax = ''
	[String]$FirstName = ''
	[Gender]$Gender = [Gender]::new()
	[String]$Hardware = ''
	[boolean]$HasContact = $false
	[String]$HypervisorParentID = ''
	[String]$HypervisorParentName = ''
	[HyperVVersion]$HyperVVersion = [HyperVVersion]::new()
	[String]$IP = ''
	[boolean]$IsEmpty = $false
	[boolean]$IsHyperVServer = $false
	[boolean]$IsJumpHost = $false
	[boolean]$IsTerminalServer = $false
	[boolean]$IsVirtualMachine = $false
	[boolean]$IsVMwareServer = $false
	[boolean]$IsXenServer = $false
	[boolean]$JumpForceNewSession = $false
	[boolean]$JumpShowWaitDialog = $true
	[String]$Keywords = ''
	[String]$LastLoadFromInventoryDate = $null
	[String]$LastName = ''
	[int]$LogicalCPUCount = 0
	[String]$MAC = ''
	[String]$MachineName = ''
	[String]$Manufacturer = ''
	[String]$Memory = ''
	[String]$MiddleName = ''
	[String]$ModelInformation = ''
	[String]$Monitors = ''
	[String]$NameLabel = ''
	[String]$Notes = ''
	[String]$OS = ''
	[RecoveryCodeItem]$OTPRecoveryCodes = [RecoveryCodeItem]::new()
	[String]$Phone = ''
	[String]$Prefix = ''
	[String]$PurchaseDate = $null
	[String]$Rack = ''
	[String]$SafeContactPassword = ''
	[String]$SafePasswordHistory = ''
	[String]$SerialNumber = ''
	[string[]]$ServerFeatureRoles = [string[]]::new()
	[String]$ServerHomePageUrl = ''
	[String]$ServerRemoteManagementUrl = ''
	[String]$ServerRemoteManagementUrlLabelOverride = ''
	[String]$ServiceTag = ''
	[String]$Site = ''
	[String]$Skype = ''
	[int]$SocketCount = 0
	[String]$SocketType = ''
	[String]$Softwares = ''
	[String]$State = ''
	[String]$SupportServiceLevel = ''
	[String]$Title = ''
	[String]$UPN = ''
	[String]$Vendor = ''
	[String]$VendorLinkID = ''
	[String]$VendorLinkUsername = ''
	[VendorMode]$VendorMode = [VendorMode]::new()
	[String]$Version = ''
	[String]$VirtualMachineName = ''
	[String]$VirtualMachineType = ''
	[String]$Warranty = $null
	[String]$Website = ''
	[String]$WorkPhone = ''
	[String]$ZipCode = ''
}
