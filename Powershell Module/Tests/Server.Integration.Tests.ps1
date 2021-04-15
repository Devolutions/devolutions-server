<#
.DESCRIPTION
    These are tests that will physically write to the backend, you should run this only
    on a "disposable" backend.
#>
Describe "Integration tests - these will pollute the backend" {
        
    BeforeAll {
        $modulePath = Resolve-Path -Path "..\DevolutionsServer"
        Import-Module -Name $modulePath -Verbose -Force
        
        if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) {
            throw "please initialize the credentials in the environment variables"  
        }

        if ([string]::IsNullOrEmpty($env:DS_URL)) {
            throw "Please initialize DS_URL environement variable."
        }
        
        [string]$credUser = $env:DS_USER
        [string]$credPassword = $env:DS_PASSWORD
        [string]$dvlsURI = $env:DS_URL
        [securestring]$secPassword = ConvertTo-SecureString $credPassword -AsPlainText -Force
        [pscredential]$creds = New-Object System.Management.Automation.PSCredential ($credUser, $secPassword)

        $sess = New-DSSession -Credential $creds -BaseURI $dvlsURI -Verbose
        if ($null -eq $sess.Body.data.tokenId) {
            throw "unable to authenticate"
        }

        #local testing context
        [string]$runSuffix = Get-Date -f MMdd_HHmmss
        [string]$testPassword = 'Pa$$w0rd!'
        #needed to share data across Pester contexts...
        $PamTemp = @{
            providerID  = ''
            TFId        = ''
            accountID   = ''
            newPolicyID = ''
        }
    }

    AfterAll {
        $res = Close-DSSession -Verbose
        $res.IsSuccess | Should -Be $true
    }

    Describe NormalWorkflow {
        Context "Connecting to server" {
            It "Should get server information" {
                $res = Get-DSServerInfo -BaseURI $dvlsURI -Verbose
                $res.Body.data.version | Should -Not -BeNullOrEmpty
            }
            It "Should authenticate" {
                $res = New-DSSession -Credential $creds -BaseURI $dvlsURI -Verbose
                $res.IsSuccess | Should -Be $true
            }
        }

        <#Custom users
        Context "Custom users" {
            It "should create new custom user" {
                $newUserData = @{
                    name                    = "Alexandre Martigny"
                    password                = 'Pa$$w0rd'
                    isChangePasswordAllowed = $false
                    address                 = "1234 Rue du Cafe"
                    cellPhone               = "123-456-7890"
                    companyName             = "Devolutions"
                    countryName             = "Canada"
                    department              = "test"
                    fax                     = "123-456-9876"
                    firstName               = "Alex"
                    jobTitle                = "test"
                    userType                = 0
                    userLicenseTypeMode     = 0
                    authenticationType      = 0
                }
        
                $res = New-DSCustomUser @newUserData -Verbose
                $res.isSuccess | Should -be $true
                $hash.newUserId = $res.Body.data.id
                return $res
            }
        }
        #>

        <#Roles
        Context 'Roles' {
        It "should create new role" {
            $newRoleData = @{
                displayName      = "Test"
                description      = "This is a test role"
                canAdd           = $true
                canDelete        = $false
                offlineMode      = 3
                allowDragAndDrop = $false
            }

            $res = New-DSRole @newRoleData -Verbose
            $hash.newRoleId = $res.Body.data.id
            $res.isSuccess | Should -be $true
        }

        It "should delete newly created role" {
            $res = Delete-DSRole -roleId $hash.newRoleId -Verbose
            $res.isSuccess | Should -be $true
        }
        
        It "should get all user groups" {
            $res = Get-DSRoles -Verbose
            $res.isSuccess | Should -be $true
        }
        
        It "should update role" {
            $updatedRoleData = @{
                candidRoleId     = $hash.newRoleId
                description      = "Ceci est un update test"
                displayName      = "It worked"
                isAdministrator  = $false
                canAdd           = $true
                canEdit          = $true
                canDelete        = $true
                allowDragAndDrop = $true
                canImport        = $true
                canExport        = $true
                offlineMode      = $true
                denyAddInRoot    = $true
            }

            $res = Update-DSRole @updatedRoleData -Verbose
            $res.isSuccess | Should -be $true
        }
    } 
        #>
        
        Context "Creating entries" {
            It "Should create a credential entry in the default vault" {
                $credParams = @{
                    VaultId   = ([guid]::Empty)
                    EntryName = "rootlocal $runSuffix"
                    Username  = "root $runSuffix"
                    Password  = $testPassword
                    Folder    = "Powershell rules $runSuffix"
                }
        
                $res = New-DSCredentialEntry @credParams -Verbose -Debug
                $res.IsSuccess | Should -Be $true
            }
        }

        Context "End to end PAM" {
            It "Should create new provider" {
                $newProviderData = @{
                    ID             = [guid]::NewGuid()
                    name           = "Pam Provider $runSuffix"
                    credentialType = 'LocalUser'
                    #TODO:ssh providers have a regex based validation in the backend, we must add more tests.
                    #random string of LOWERCASE...
                    username       = -join ((97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ })
                }
        
                $res = New-DSPamProvider @newProviderData -Debug

                $PamTemp.providerID = $res.Body.id
                $res.isSuccess | Should -be $true
            }
            
            It "Should create new folder at root" {
                $newFolderData = @{
                    name = "Pam Folder $runSuffix"
                }
        
                $res = New-DSPamTeamFolder @newFolderData -Debug

                $PamTemp.TFId = $res.Body.id
                $res.isSuccess | Should -be $true
            }

            It "Should create new folder in newly created folder" {
                $newFolderData = @{
                    name = "Pam Folder 2 $runSuffix"
                }
        
                $res = New-DSPamTeamFolder @newFolderData -Debug
                $PamTemp.TFId = $res.Body.id
                $res.isSuccess | Should -be $true
            }

            It "Should create new PAM account" {
                $pamAccountParams = @{
                    credentialType    = 2
                    protectedDataType = 1
                    folderID          = $PamTemp.TFId
                    label             = "Pam account $runSuffix"
                    username          = -join ((97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ })
                    adminCredentialID = $PamTemp.providerID
                    password          = $testPassword
                }
        
                $res = New-DSPamAccount @pamAccountParams

                $PamTemp.accountID = $res.Body.id
                $res.StandardizedStatusCode | Should -be 201
            }

            It "Should get PAM Accounts" {    
                $res = Get-DSPamAccounts -folderID $PamTemp.TFId -Verbose
                $res.StandardizedStatusCode | Should -be 200
                $res.IsSuccess | Should -be $true
            }

            It "Should delete created PAM account" {
                $res = Remove-DSPamAccount -pamAccountID $PamTemp.accountID
                $res.StandardizedStatusCode | Should -be 204
                $res.isSuccess | Should -be $true
            }

            It "Should delete created folder" {
                $res = Remove-DSPamFolder $PamTemp.TFId -Verbose
                $res.StandardizedStatusCode | Should -be 204
                $res.isSuccess | Should -be $true
            }

            It "Should delete created provider" {
                $res = Remove-DSPamProvider $PamTemp.providerID -Verbose
                $res.StandardizedStatusCode | Should -be 204
                $res.isSuccess | Should -be $true
            }
        }

        #TODO: the endpoint returns singletons but should always return an array, lets put this on the ice for now
        # Context "PAM Checkout Policies" {
        #     It "Should create new checkout policy" {
        #         $policyInfos = @{
        #             name                         = "integrationtest"
        #             checkoutApprovalMode         = 1
        #             checkoutReasonMode           = 2
        #             allowCheckoutOwnerAsApprover = 1
        #             includeAdminsAsApprovers     = 2
        #             includeManagersAsApprovers   = 1
        #             checkoutTime                 = 200
        #             isDefault                    = $true
        #         }

        #         $res = New-DSPamCheckoutPolicy @policyInfos

        #         #needed to share data across test contexts...
        #         $PamTemp.newPolicyID = $res.Body.id
        #         $res.isSuccess | Should -be $true
        #     }

        #     It "Should get all checkout policies" {
        #         $res = Get-DSPamCheckoutPolicies
        #         $res.isSuccess | Should -be $true
        #     }

        #     It "Should get newly created checkout policy" {
        #         $res = Get-DSPamCheckoutPolicies -policyID $PamTemp.newPolicyID
        #         $res.isSuccess | Should -be $true
        #     }

        #     It "Should delete newly created checkout policy" {
        #         $res = Remove-DSPamCheckoutPolicy -candidPolicyID $PamTemp.newPolicyID
        #         $res.isSuccess | Should -be $true
        #     }
        # }
    }
}
