<#
.DESCRIPTION
    These are tests that will simply exercise the backend without creating new info
    Obviously except logs and session information.  It does expect a seeded system
    so its mostly for internal Devolutions use at this time.  In the future
    we will create seed data using this module.
#>
BeforeAll {
    $modulePath = Resolve-Path -Path '..\Devolutions.Server'
    Import-Module -Name $modulePath  -Force
    
    if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) {
        throw 'please initialize the credentials in the environment variables'  
    }

    if ([string]::IsNullOrEmpty($env:DS_URL)) {
        throw 'Please initialize DS_URL environement variable.'
    }
          
    [string]$credUser = $env:DS_USER
    [string]$credPassword = $env:DS_PASSWORD
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseDeclaredVarsMoreThanAssignments', '', Justification = 'False positive in Pester tests')]
    [string]$dvlsURI = $env:DS_URL

    [securestring]$secPassword = ConvertTo-SecureString $credPassword -AsPlainText -Force
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute('UseDeclaredVarsMoreThanAssignments', '', Justification = 'False positive in Pester tests')]
    [pscredential]$creds = New-Object System.Management.Automation.PSCredential ($credUser, $secPassword)

    $sess = New-DSSession -Credential $creds -URL $dvlsURI 
    if ($null -eq $sess.Body.data.tokenId) {
        throw 'unable to authenticate'
    }
}

Describe NormalWorkflow {
    #TODO:MC:reinstate this
    #    Context "Server Information" {
    #        It "Should get server information" {
    #            $res = Get-DSServerInfo -BaseURI $dvlsURI 
    #            $res.Body.data.version | Should -Not -BeNullOrEmpty
    #        }
    #    }

    Context 'Vault Endpoints' {
        It 'Should get at least the Default Vault' {
            $res = Get-DSVaults -PageNumber 1 -PageSize 100 
            $res.IsSuccess | Should -Be $true
        }
        It 'Should sort' {
            $res = Get-DSVaults -Sortfield 'Name' 
            $res.IsSuccess | Should -Be $true
        }
        It 'Should sort' {
            $res = Get-DSVaults -Sortfield 'Name' -Descending 
            $res.IsSuccess | Should -Be $true
        }
        It 'Should respond with error' {
            $res = Get-DSVaults -PageNumber 100 -PageSize 1 
            $res.StandardizedStatusCode | Should -Be '416'
        }

        It 'Should get at least the Default Vault' {
            $res = Get-DSVault -VaultID ([guid]::Empty)
            $res.IsSuccess | Should -Be $true
        }

        It 'Should get the default Vault permissions - Applications' {
            $principals = [array](Get-DSVaultPermissions -VaultID ([guid]::Empty) -PrincipalTypes 'Applications')
            Write-Debug $principals.Length
        }
        It 'Should get the default Vault permissions - Users' {
            $principals = [array](Get-DSVaultPermissions -VaultID ([guid]::Empty) -PrincipalTypes 'Users')
            Write-Debug $principals.Length
        }
        It 'Should get the default Vault permissions - Roles' {
            $principals = [array](Get-DSVaultPermissions -VaultID ([guid]::Empty) -PrincipalTypes 'Roles') 
            Write-Debug $principals.Length
        }
        It 'Should get the default Vault permissions - All' {
            $principals = [array](Get-DSVaultPermissions -VaultID ([guid]::Empty) -PrincipalTypes 'All') 
            Write-Debug $principals.Length
        }
        
    } #context Vault endpoints

    Context 'Entries' {

        It 'Should access entry details' {
            if ($null -ne $entries) {
                for ($i = 0; $i -lt $entries.Count; $i++) {
                    $entryId = $entries[$i].id
                    $innerRes1 = Get-DSEntry $entryId  
                    $innerRes1.Body.Data.Name | Should -Not -BeNullOrEmpty

                    $getSD = $innerRes1.Body.Data.Data.passwordItem.hasSensitiveData
                    if (($null -ne $getSD) -and ($true -eq $getSD)) {
                        $innerRes2 = Get-DSEntrySensitiveData $entryId
                        $innerRes2.Body.Data | Should -Not -BeNullOrEmpty
                    }
                }
            }
        }

        BeforeAll {
            $res = Get-DSEntries -VaultId ([guid]::Empty) 
            $res.IsSuccess | Should -Be $true
            $entries = [array]$res.body.data
            write-debug $entries.Length
        }
    }
    
    AfterAll {
        Close-DSSession    
    }

    Context 'SecureMessages' {
        It 'Should list messages' {
            $res = Get-DSSecureMessages 
            $res.IsSuccess | Should -Be $true }
    }

    Context 'PAM' {
        It 'should list pam providers' {
            $res = Get-DSPamProviders 
            $res.IsSuccess | Should -Be $true
            #$res.Body -is [system.array] | Should -Be $true
        }

        It 'should list pam folders' {
            $res = Get-DSPamFolders 
            $res.IsSuccess | Should -Be $true
            $res.Body.Data -is [system.array] | Should -Be $true
        }

        # It "Should get all checkout policies" {
        #     $res = Get-DSPamCheckoutPolicies 
        #     $res.isSuccess | Should -be $true
        # }
    }
}
