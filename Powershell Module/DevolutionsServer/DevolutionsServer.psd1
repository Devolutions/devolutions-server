#
# Module manifest for module 'DevolutionsServer'
#
@{
    # Script module or binary module file associated with this manifest.
    RootModule             = 'DevolutionsServer.psm1'
    
    # Version number of this module.
    ModuleVersion          = '2021.3.0'

    # Supported PSEditions
    CompatiblePSEditions   = 'Desktop', 'Core'

    # ID used to uniquely identify this module
    GUID                   = '1E867BE1-DB19-4260-B768-6A368276B470'

    # Author of this module
    Author                 = 'Devolutions'

    # Company or vendor of this module
    CompanyName            = 'Devolutions'

    # Copyright statement for this module
    Copyright              = '(c) 2021 Devolutions Inc. All rights reserved.'

    # Description of the functionality provided by this module
    Description            = 'Devolutions Server PowerShell Module'

    # Minimum version of the PowerShell engine required by this module
    PowerShellVersion      = '5.1'
    
    # Name of the PowerShell host required by this module
    # PowerShellHostName = ''
    
    # Minimum version of the PowerShell host required by this module
    # PowerShellHostVersion = ''
    
    # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    DotNetFrameworkVersion = '4.7.2'
    
    # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
    CLRVersion             = '4.0'
    
    # Processor architecture (None, X86, Amd64) required by this module
    # ProcessorArchitecture = ''
    
    # Modules that must be imported into the global environment prior to importing this module
    # RequiredModules = @()
    
    # Assemblies that must be loaded prior to importing this module
    RequiredAssemblies     = @('.\DvlsAPI.dll')
    
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    # ScriptsToProcess = @()
    
    # Type files (.ps1xml) to be loaded when importing this module
    # TypesToProcess = @()
    
    # Format files (.ps1xml) to be loaded when importing this module
    # FormatsToProcess = @()
    
    # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
    NestedModules          = @()
    
    FunctionsToExport      = @('Get-DSServerInfo', 'New-DSSession', 'Close-DSSession', 'Protect-ResourceToHexString',
        'Get-DSSecureMessages',
        'Get-DSVaults', 'Get-DSVault', 'Get-DSVaultPermissions', 
        'Get-DSEntries', 'Get-DSEntry', 'Get-DSEntrySensitiveData', 'Get-DSEntriesTree', 'Get-DSFolder', 'Get-DSEntriesPermissions'
        'New-DSCredentialEntry', 
        'Get-DSPamProviders', 'New-DSPamProvider', 'Remove-DSPamProvider', 'Update-DSPamProvider', 
        'Get-DSPamFolders', 'Get-DSPamFolder', 'New-DSPamTeamFolder', 'Remove-DSPamFolder', 'Update-DSPamFolder', 
        'Get-DSPamAccounts', 'New-DSPamAccount', 'Remove-DSPamAccount', 
        #'Get-DSPamCheckoutPolicies', 'New-DSPamCheckoutPolicy', 'Remove-DSPamCheckoutPolicy', 'Update-DSPamCheckoutPolicy',
        'New-DSRole', 'Get-DSRoles', 'Update-DSRole', 'Remove-DSRole',
        'New-DSCustomUser', 'Update-DSCustomUser', 'Remove-DSUser', 'Get-DSUsers')
    
    # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
    CmdletsToExport        = @()
    
    # Variables to export from this module
    VariablesToExport      = @()
    
    # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
    AliasesToExport        = @()
    
    # DSC resources to export from this module
    # DscResourcesToExport = @()
    
    # List of all modules packaged with this module
    # ModuleList = @()
    
    # List of all files packaged with this module
    # FileList = @()
    
    # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
    PrivateData            = @{

        PSData = @{

            # Tags applied to this module. These help with module discovery in online galleries.
            Tags       = 'Devolutions', 'Server', 'PAM', 'RemoteDesktop', 'RDM'

            # A URL to the license for this module.
            LicenseUri = 'https://github.com/Devolutions/devolutionsserver/blob/master/LICENSE'

            # A URL to the main website for this project.
            ProjectUri = 'https://github.com/Devolutions/devolutionsserver'

            # A URL to an icon representing this module.
            IconUri    = 'https://raw.githubusercontent.com/Devolutions/devolutions-server/main/logo.png'

            # ReleaseNotes of this module
            # ReleaseNotes = ''

            # Prerelease string of this module
            #Prerelease = 'rc1'

            # Flag to indicate whether the module requires explicit user acceptance for install/update/save
            # RequireLicenseAcceptance = $false

            # External dependent modules of this module
            # ExternalModuleDependencies = @()

        } # End of PSData hashtable

    } # End of PrivateData hashtable
    # HelpInfo URI of this module
    # HelpInfoURI = ''
    
    # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
    # DefaultCommandPrefix = ''
    
}
