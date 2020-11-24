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
    It "Should authenticate" {
        $res = New-DSSession -Credential $creds -BaseURI $dvlsURI -Verbose
        $res.Body.data.tokenId | Should -Not -BeNullOrEmpty
    }
    It "Should get at least the Default Vault" {
        $res = Get-DSVaults -Verbose
        $res.Body.data.Length | Should -BeGreaterThan 0
    }
    It "should logoff" {
        $res = Close-DSSession -Verbose   
        $res.IsSuccess | Should -Be $true
    }
}
