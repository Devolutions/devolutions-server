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
            folderID    = ''
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

                #needed to share data across test contexts...
                $PamTemp.providerID = $res.Body.id
                $res.isSuccess | Should -be $true
            }
            It "Should create new folder" {
                $newFolderData = @{
                    ID = $null #[guid]::NewGuid() the backend assumes too much...
                    name     = "Pam Folder $runSuffix"
                }
        
                $res = New-DSPamTeamFolder @newFolderData -Debug

                #needed to share data across test contexts...
                $PamTemp.folderID = $res.Body.id
                $res.isSuccess | Should -be $true
            }

            It "Should create new PAM account" {
                $pamAccountParams = @{
                    credentialType    = 2
                    protectedDataType = 1
                    folderID          = $PamTemp.folderID
                    label             = "Pam account $runSuffix"
                    username          = -join ((97..122) | Get-Random -Count 8 | ForEach-Object { [char]$_ })
                    adminCredentialID = $PamTemp.providerID
                    password          = $testPassword
                }
        
                $res = New-DSPamAccount @pamAccountParams

                #needed to share data across test contexts...
                $PamTemp.accountID = $res.Body.id
                $res.StandardizedStatusCode | Should -be 201
            }

            It "Should get PAM Accounts" {    
                $res = Get-DSPamAccounts -folderID $PamTemp.folderID -Verbose
                #TODO:Validate that the one we created is as expected
                $res.IsSuccess | Should -be $true
            }

            It "Should delete created PAM account" {

                #needed to share data across test contexts...
                $res = Remove-DSPamAccount -pamAccountID $PamTemp.accountID
                #TODO:VALIDATE result http 204
                $res.isSuccess | Should -be $true
            }

            It "Should delete created folder" {

                #needed to share data across test contexts...
                $res = Remove-DSPamFolder $PamTemp.folderID -Verbose
                #TODO:validate result http 204
                $res.isSuccess | Should -be $true
            }

            It "Should delete created provider" {
                #TODO:Implement Remove-DSPamProvider
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
