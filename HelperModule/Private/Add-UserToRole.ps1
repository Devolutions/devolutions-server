function Add-UserToRole {
    param(
        [Parameter(Mandatory)][string]$server,
        [Parameter(Mandatory)][String]$Database,
        [Parameter(Mandatory)][string]$User,
        [Parameter(Mandatory)][string]$Role)

    $Svr = New-Object ('Microsoft.SqlServer.Management.Smo.Server') $server
    #Check Database Name entered correctly
    $db = $svr.Databases[$Database]
    if ($null -eq $db) {
        Write-LogEvent " $Database is not a valid database on $Server"
        Write-LogEvent " Databases on $Server are :" -Output
        $svr.Databases | Select-Object name
        break
    }
    #Check Role exists on Database
    $Rol = $db.Roles[$Role]
    if ($null -eq $Rol) {
        Write-LogEvent " $Role is not a valid Role on $Database on $Server  "
        Write-LogEvent " Roles on $Database are:" -Output
        $db.roles | Select-Object name
        break
    }
    if (!($svr.Logins.Contains($User))) {
        Write-LogEvent "$User not a login on $server please create it first"
        break
    }
    if (!($db.Users.Contains($User))) {
        # Add user to database

        $usr = New-Object ('Microsoft.SqlServer.Management.Smo.User') ($db, $User)
        $usr.Login = $User
        $usr.Create()

        #Add User to the Role
        $Rol = $db.Roles[$Role]
        $Rol.AddMember($User)
        Write-LogEvent "$User was not a login on $Database on $server"
        Write-LogEvent "$User added to $Database on $Server and $Role Role"
    } else {
        #Add User to the Role
        $Rol = $db.Roles[$Role]
        $Rol.AddMember($User)
        Write-LogEvent "$User added to $Role Role in $Database on $Server "
    }
}