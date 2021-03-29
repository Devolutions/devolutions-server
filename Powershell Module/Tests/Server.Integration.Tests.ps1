<#
.DESCRIPTION
    These are tests that will physically write to the backend, you should run this only
    on a "disposable" backend.
#>
BeforeAll {
    $modulePath = Resolve-Path -Path "..\DevolutionsServer"
    Import-Module -Name $modulePath -Verbose -Force
    $hash = @{
        dvlsURI      = 'http://localhost/dvls'
        pamAccountID = ''
        folderID     = ''
        newPolicyID = ''
    }
    
    if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) {
        throw "please initialize the credentials in the environment variables"  
    }
      
    [string]$credUser = $env:DS_USER
    [string]$credPassword = $env:DS_PASSWORD
    [securestring]$secPassword = ConvertTo-SecureString $credPassword -AsPlainText -Force
    [pscredential]$creds = New-Object System.Management.Automation.PSCredential ($credUser, $secPassword)
}

Describe NormalWorkflow {
    Context "Connecting to server" {
        It "Should get server information" {
            $res = Get-DSServerInfo -BaseURI $hash.dvlsURI -Verbose
            $res.Body.data.version | Should -Not -BeNullOrEmpty
        }
        It "Should authenticate" {
            $res = New-DSSession -Credential $creds -BaseURI $hash.dvlsURI -Verbose
            $res.IsSuccess | Should -Be $true
        }
    }

    Context "Creating entries" {
        It "Should create a credential entry" {
            $credParams = @{
                VaultId   = '00000000-0000-0000-0000-000000000000'
                EntryName = "rootlocal $(Get-Date -Format "o")"
                Username  = 'root'
                Password  = '123456'
                Folder    = "Powershell rules"
            }
    
            $res = New-DSCredentialEntry @credParams -Verbose -Debug
            $res.IsSuccess | Should -Be $true
        }
    }

    Context "Manipulating PAM account" {
        It "Should create new PAM account" {
            $pamAccountParams = @{
                credentialType    = 2
                protectedDataType = 1
                folderID          = "6b0b852b-c335-4a2a-b256-e9515d5e7cdd"
                label             = "Yepper"
                username          = "scripttest"
                adminCredentialID = "cff6d374-7b40-43e1-8108-7e99b56af75a"
                password          = "123"
            }
    
            $res = New-DSPamAccount @pamAccountParams
            $hash.pamAccountID = $res.Body.id
            $res.StandardizedStatusCode | Should -be 201
        }

        It "Should get PAM Accounts" {    
            $res = Get-DSPamAccounts -Verbose
            $res.IsSuccess | Should -be $true
        }

        It "Should delete created PAM account" {
            $res = Remove-DSPamAccount -pamAccountID $hash.pamAccountID
            $res.isSuccess | Should -be $true
        }
    }

    Context "PAM Folders" {
        It "Should create new folder" {
            $newFolderData = @{
                folderID = "ae7884bd-e8e9-4c17-b03e-7ae61b19797e"
                name     = "Ouioui"
            }
    
            $res = New-DSPamFolder @newFolderData -Debug
            $hash.folderID = $res.Body.id
            $res.isSuccess | Should -be $true
        }

        It "Should get created folder" {
            $res = Get-DSPamFolders -Verbose
            $res.isSuccess | Should -be $true
        }

        It "Should delete created folder" {
            $res = Remove-DSPamFolder $hash.folderID -Verbose
            $res.isSuccess | Should -be $true
        }
    }

    Context "PAM Checkout Policies" {
        It "Should create new checkout policy" {
            $policyInfos = @{
                name                         = "integrationtest"
                checkoutApprovalMode         = 1
                checkoutReasonMode           = 2
                allowCheckoutOwnerAsApprover = 1
                includeAdminsAsApprovers     = 2
                includeManagersAsApprovers   = 1
                checkoutTime                 = 200
                isDefault                    = $true
            }

            $res = New-DSPamCheckoutPolicy @policyInfos
            $hash.newPolicyID = $res.Body.id
            $res.isSuccess | Should -be $true
        }

        It "Should get count of checkout policies" {
            $res = Get-DSPamCheckoutPolicies -Count
            $res.isSuccess | Should -be $true
        }

        It "Should get all checkout policies" {
            $res = Get-DSPamCheckoutPolicies
            $res.isSuccess | Should -be $true
        }

        It "Should get newly created checkout policy" {
            $res = Get-DSPamCheckoutPolicies -policyID $hash.newPolicyID
            $res.isSuccess | Should -be $true
        }

        It "Should delete newly created checkout policy" {
            $res = Remove-DSPamCheckoutPolicy -candidPolicyID $hash.newPolicyID
            $res.isSuccess | Should -be $true
        }
    }

    It "Should logoff" {
        $res = Close-DSSession -Verbose   
        $res.IsSuccess | Should -Be $true
    }
}
