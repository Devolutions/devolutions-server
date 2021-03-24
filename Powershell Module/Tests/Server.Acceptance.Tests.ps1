<#
.DESCRIPTION
    These are tests that will simply exercise the backend without creating new info
    Obviously except logs and session information.

    This assumes that data exists in the server...

    When we are further along we will be able to create the seed data with the module.
#>
BeforeAll {
    $modulePath = Resolve-Path -Path "..\DevolutionsServer"
    Import-Module -Name $modulePath -Verbose -Force
    $dvlsURI = "http://localhost/dps"
    
    if (-Not(Test-Path env:DS_USER) -or -Not(Test-Path env:DS_PASSWORD)) {
        throw "please initialize the credentials in the environment variables"  
    }
          
    [string]$credUser = $env:DS_USER
    [string]$credPassword = $env:DS_PASSWORD
    [securestring]$secPassword = ConvertTo-SecureString $credPassword -AsPlainText -Force
    [pscredential]$creds = New-Object System.Management.Automation.PSCredential ($credUser, $secPassword)
}

Describe NormalWorkflow{
     It "Should get server information" {
         $res = Get-DSServerInfo -BaseURI $dvlsURI -Verbose
         $res.Body.data.version | Should -Not -BeNullOrEmpty
        }
    It "Should authenticate" {
        $res = New-DSSession -Credential $creds -BaseURI $dvlsURI -Verbose
        $res.IsSuccess | Should -Be $true
    }

    Context "Vault Endpoints" {
        It "Should get at least the Default Vault" {
            $res = Get-DSVaults -PageNumber 1 -PageSize 100 -Verbose
            $res.IsSuccess | Should -Be $true
        }
        It "Should sort" {
            $res = Get-DSVaults -Sortfield 'Name' -Verbose
            $res.IsSuccess | Should -Be $true
        }
        It "Should sort" {
            $res = Get-DSVaults -Sortfield 'Name' -Descending -Verbose
            $res.IsSuccess | Should -Be $true
        }
        It "Should respond with error" {
            $res = Get-DSVaults -PageNumber 100 -PageSize 1 -Verbose
            $res.StandardizedStatusCode | Should -Be '416'
        }
    } #context Vault endpoints

    Context "Entries" {

        It "Should access entry details" {
            if ($null -ne $entries) {
                for ($i = 0; $i -lt $entries.Count; $i++) {
                    $entryId = $entries[$i].id
                    $innerRes1 = Get-DSEntry $entryId -Verbose # | Should -Not -Throw
                    $innerRes1.Body.Data.Name | Should -Not -BeNullOrEmpty

                    $getSD = $innerRes1.Body.Data.Data.passwordItem.hasSensitiveData
                    if (($null -ne $getSD) -and ($true -eq $getSD)){
                        $innerRes2 = Get-DSEntrySensitiveData $entryId -Verbose # | Should -not -Throw
                        #$innerRes2.Body.result | Should -BeGreaterThan 0
                    }
                }
            }
        }

        BeforeAll {
            $entries = $null
            $res = Get-DSEntries -VaultId '00000000-0000-0000-0000-000000000000' -Verbose
            $res.IsSuccess | Should -Be $true
            $entries = $res.body.data
        }
    }
    
    AfterAll{
        $res = Close-DSSession -Verbose   
        $res.IsSuccess | Should -Be $true
    }

    Context "SecureMessages" {
        It "Should list messages" {
            $res = Get-DSSecureMessages -Verbose
            $res.IsSuccess | Should -Be $true        }
    }

    Context "PAM" {
        It "should list pam folders" {
            $res = Get-DSPamFolders -Verbose
            $res.IsSuccess | Should -Be $true
            $res.Body.Data -is [system.array] | Should -Be $true
        }
    }
}
