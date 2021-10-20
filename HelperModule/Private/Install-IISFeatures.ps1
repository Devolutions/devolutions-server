function Install-IISFeatures {
    Import-Module ServerManager
    Install-IISPrerequisite 'Web-Server'
    Install-IISPrerequisite 'Web-Http-Errors'
    Install-IISPrerequisite 'Web-Http-Logging'
    Install-IISPrerequisite 'Web-Static-Content'
    Install-IISPrerequisite 'Web-Default-Doc'
    Install-IISPrerequisite 'Web-Dir-Browsing'
    Install-IISPrerequisite 'Web-AppInit'
    Install-IISPrerequisite 'Web-Net-Ext45'
    Install-IISPrerequisite 'Web-Asp-Net45'
    Install-IISPrerequisite 'Web-ISAPI-Ext'
    Install-IISPrerequisite 'Web-ISAPI-Filter'
    Install-IISPrerequisite 'Web-Basic-Auth'
    Install-IISPrerequisite 'Web-Digest-Auth'
    Install-IISPrerequisite 'Web-Stat-Compression'
    Install-IISPrerequisite 'Web-Windows-Auth'
}