<#
.DESCRIPTION
    These are tests that will physically write to the backend, you should run this only
    on a "disposable" backend.
#>
Describe "Integration tests - these will pollute the backend" {
      
    Context "Creating entries" {
        # It "Should create a credential entry in the default vault" {
        #     $credParams = @{
        #         VaultId                                  = ([guid]::Empty)
        #         EntryName                                = "rootlocal $runSuffix"
        #         Username                                 = "root $runSuffix"
        #         Password                                 = $testPassword
        #         Folder                                   = "Powershell rules $runSuffix"
        #         credentialViewedCommentIsRequired        = $true
        #         credentialViewedPrompt                   = $true
        #         ticketNumberIsRequiredOnCredentialViewed = $true
        #         checkOutMode                             = "Default"
        #         Description                              = "This is a description"
        #         Tags                                     = "1 2 3 4 5"
        #     }
        
        #     $res = New-DSCredentialEntry @credParams
        #     $Temp["credID"] = $res.Body.data.id
        #     $res.IsSuccess | Should -Be $true
        # }

        # It "should update values for newly created entry" {
        #     $credParams = @{
        #         CandidEntryID                            = $Temp.credID
        #         VaultId                                  = ([guid]::Empty)
        #         EntryName                                = "updated"
        #         Username                                 = "root $runSuffix"
        #         Password                                 = $testPassword
        #         Folder                                   = "Powershell rules $runSuffix"
        #         credentialViewedCommentIsRequired        = $true
        #         credentialViewedPrompt                   = $true
        #         ticketNumberIsRequiredOnCredentialViewed = $true
        #         checkOutMode                             = "Default"
        #         Description                              = "This is a description"
        #         Tags                                     = "1 2 3 4 5"
        #     }
    
        #     $res = Update-DSEntry @credParams
        #     $res.Body.data.name | Should -be "updated"
        #     $res.isSuccess | Should -be $true
        # }


        # It "should delete newly created entry" {
        #     $res = Remove-DSEntry -CandidEntryID $Temp.credID
        #     $res.isSuccess | Should -be $true
        # }


        It "Should create a RDP entry in the default vault" {
            $credParams = @{
                VaultId                                  = ([guid]::Empty)
                EntryName                                = "windjammer $runSuffix"
                HostName                                 = "windjammer $runSuffix"
                Username                                 = "root $runSuffix"
                Password                                 = $testPassword
                Folder                                   = "Powershell rules $runSuffix"
                Description                              = "This is a description"
                Tags                                     = "1 2 3 4 5"
            }
        
            $res = New-DSRDPEntry @credParams
            #$Temp["credID"] = $res.Body.data.id
            $res.IsSuccess | Should -Be $true
        }

    }


    BeforeAll {
        $modulePath = Resolve-Path -Path "..\DevolutionsServer"
        Import-Module -Name $modulePath -Force
            
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
    
        $sess = New-DSSession -Credential $creds -BaseURI $dvlsURI
        if ($null -eq $sess.Body.data.tokenId) {
            throw "unable to authenticate"
        }
    
        #local testing context
        [string]$runSuffix = Get-Date -f MMdd_HHmmss
        [string]$testPassword = 'Pa$$w0rd!'

        $PamTemp = @{
            providerID  = ''
            TFId        = ''
            accountID   = ''
            newPolicyID = ''
        }

        $Temp = @{}
    }
    
    AfterAll {
        $res = Close-DSSession
        $res.IsSuccess | Should -Be $true
    }
}

