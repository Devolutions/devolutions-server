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
