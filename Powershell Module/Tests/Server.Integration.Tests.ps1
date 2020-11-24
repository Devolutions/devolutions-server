<#
.DESCRIPTION
    These are tests that will physically write to the backend, you should run this only
    on a "disposable" backend.
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

    Context "Creating entries" {
        It "Should create a credential entry" {
            $credParams = @{
                vaultID = '00000000-0000-0000-0000-000000000000'
                SessionName = "rootlocal $(Get-Date -Format "o")"
                Username = 'root'
                Password = '123456'
                Folder = "Powershell rules"
            }
    
            $res = New-DSCredentialEntry @credParams -Verbose -Debug
            $res.IsSuccess | Should -Be $true
        }
    }

    It "Should logoff" {
        $res = Close-DSSession -Verbose   
        $res.IsSuccess | Should -Be $true
    }
}
