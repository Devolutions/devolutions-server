<#
.DESCRIPTION
    These are tests that will simply exercise the backend without creating new info
    Obviously except logs and session information.
#>
BeforeAll {
    $modulePath = Resolve-Path -Path "..\DevolutionsServer"
    Import-Module -Name $modulePath -Verbose -Force
    $dvlsURI = "http://localhost/dps"
    
    if (-Not(Test-Path env:DS_USER)) {
        throw "please use login to initialize the credentials in the environment variables"  
      }
      
      if (-Not(Test-Path env:DS_PASSWORD)) {
        throw "please use login to initialize the credentials in the environment variables"
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

    It "Should logoff" {
        $res = Close-DSSession -Verbose   
        $res.IsSuccess | Should -Be $true
    }
}
