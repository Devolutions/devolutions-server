function New-DSSession {
    <#
        .SYNOPSIS
		Establishes a connection with your Devolutions Server instance.
		.DESCRIPTION
		Establishes a connection with your Devolutions Server by retrieving server informations and setting global variables that are required for accessing the API.
		.EXAMPLE
        $SecurePassword = ConvertTo-SecureString 'YourPassword' -AsPlainText -Force
		$SessionData = @{
			BaseURI = "Your/DVLS/Instance/URL"
			Credentials = New-Object System.Management.Automation.PSCredential ($YourUsername, $SecurePassword)
		}

		> New-DSSession @SessionData

		.EXAMPLE
		$SecurePassword = ConvertTo-SecureString $YourPassword -AsPlainText -Force
		$Credentials = New-Object System.Management.Automation.PSCredential ($YourUsername, $SecurePassword)
		$BaseURI = "Your/DVLS/Instance/URL"

		> New-DSSession -Credentials $Credentials -baseURI $URI

        .EXAMPLE
        # Authenticate using an application user

		$SecurePassword = ConvertTo-SecureString $YourApplicationSecret -AsPlainText -Force
		$Credentials = New-Object System.Management.Automation.PSCredential ($YourApplicationKey, $SecurePassword)
		$BaseURI = "Your/DVLS/Instance/URL"

		> New-DSSession -Credentials $Credentials -baseURI $URI -AsApplication
    #>
    [CmdletBinding()]
    PARAM (
        #PSCredential with your Devolutions Server username and password
        #[ValidateNotNull()]
        [object]$Credential = $null,
        #URL to your Devolutions Server instance
        [ValidateNotNullOrEmpty()]
        [string]$BaseUri = $(throw "You must provide your DVLS instance's URI."),
        #Required when using an application user to authenticate
        [switch]$AsApplication,
        [string]$DomainId
    )
    
    BEGIN {
        Write-Verbose '[Login] Beginning...'
    }
    
    PROCESS {
        #1. Fetch server information
        try {
            $ServerResponse = Invoke-WebRequest -Uri "$BaseURI/api/public-instance-information" -Method 'GET' -SessionVariable Global:WebSession

            if ((Test-Json $ServerResponse.Content -ErrorAction SilentlyContinue) -and 
                -not @(@('data', 'result') | Where-Object { (ConvertFrom-Json $ServerResponse.Content).PSObject.Properties.Name -notcontains $_ }).Count) {
                $ServerResponse = ConvertFrom-Json $ServerResponse.Content -Depth 10

                if ($ServerResponse.result -ne [SaveResult]::Success) {
                    throw '[New-DSSession] Unhandled error while fetching server information. Please submit a ticket if problem persists.'
                }
            }
            else {
                throw "[New-DSSession] There was a problem reaching your DVLS instance. Either you provided a wrong URL or it's not pointing to a DVLS instance."
            }
        }
        catch {
            Write-Error $_.Exception.Message -ErrorAction Stop
        }

        #2. Setting server related variables
        Set-Variable -Name DSBaseURI -Value $BaseUri -Scope Script
        Set-Variable -Name DSInstanceVersion -Value $ServerResponse.data.version -Scope Global

        #3. Fetching token information (Actually logging in to DVLS)
        if (!$AsApplication) {
            $LoginResponse = New-DSSessionOAuth $Credential $BaseUri $DomainId

            if ($null -eq $LoginResponse.access_token) {
                throw '[New-DSSession] Unhandled error while logging in. Please submit a ticket if problem persists.'
            }

            return $LoginResponse
        }
        else {
            $ModuleVersion = (Get-Module Devolutions.Server).Version.ToString()
    
            $RequestParams = @{
                URI         = "$BaseUri/api/login/partial"
                Method      = 'POST'
                ContentType = 'application/json'
                WebSession  = $Global:WebSession
                Body        = ConvertTo-Json @{
                    userName        = $Credential.UserName
                    LoginParameters = @{
                        Password         = $Credential.GetNetworkCredential().Password
                        Client           = $AsApplication ? [ApplicationSource]::Cli : [ApplicationSource]::Scripting
                        Version          = $ModuleVersion
                        LocalMachineName = [System.Environment]::MachineName
                        LocalUserName    = [System.Environment]::UserName
                    }
                } -Depth 3
            }
    
            try {
                $LoginResponse = Invoke-WebRequest @RequestParams
    
                if ((Test-Json $LoginResponse.Content -ErrorAction SilentlyContinue) -and 
                    -not @(@('data', 'result') | Where-Object { (ConvertFrom-Json $LoginResponse.Content).PSObject.Properties.Name -notcontains $_ }).Count) {
                    $LoginContent = ConvertFrom-Json $LoginResponse.Content
    
                    if ($LoginContent.result -ne [SaveResult]::Success) {
                        throw $LoginContent.data.message
                    }
                }
                else {
                    throw '[New-DSSession] Unhandled error while logging in. Please submit a ticket if problem persists.'
                }
            }
            catch {
                throw $_.Exception.Message
            }
            
            Set-Variable -Name DSSessionToken -Value $LoginContent.data.tokenId -Scope Global
            $Global:WebSession.Headers.Add('tokenId', $LoginContent.data.tokenId)
    
            $NewResponse = New-ServerResponse -response $LoginResponse -method 'POST'
            return $NewResponse
        }
    }
    
    END {
        if (Get-Variable -Name NewResponse -ErrorAction SilentlyContinue) {
            $Success = $NewResponse.isSuccess
        }
        else {
            $Success = $null -ne $LoginResponse.access_token
        }

        Write-Verbose ($Success ? 
            '[New-DSSession] Successfully logged in to Devolutions Server' : 
            '[New-DSSession] Could not log in. Please verify URL and credential.')
    }
}