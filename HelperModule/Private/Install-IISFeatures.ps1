function Install-IISFeatures {
    Import-Module ServerManager
    Install-PrerequisiteServer 'Web-Server'
    Install-PrerequisiteServer 'Web-Http-Errors'
    Install-PrerequisiteServer 'Web-Http-Logging'
    Install-PrerequisiteServer 'Web-Static-Content'
    Install-PrerequisiteServer 'Web-Default-Doc'
    Install-PrerequisiteServer 'Web-Dir-Browsing'
    Install-PrerequisiteServer 'Web-AppInit'
    Install-PrerequisiteServer 'Web-Net-Ext45'
    Install-PrerequisiteServer 'Web-Asp-Net45'
    Install-PrerequisiteServer 'Web-ISAPI-Ext'
    Install-PrerequisiteServer 'Web-ISAPI-Filter'
    Install-PrerequisiteServer 'Web-Basic-Auth'
    Install-PrerequisiteServer 'Web-Digest-Auth'
    Install-PrerequisiteServer 'Web-Stat-Compression'
    Install-PrerequisiteServer 'Web-Windows-Auth'
}