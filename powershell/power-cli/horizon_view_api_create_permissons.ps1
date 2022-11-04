#Loop for mode detection
do
{
$Mode = Read-Host "Type 'i' - for interractive mode or 'n'.Type 'q' for Exit"
} until (($Mode -like 'i') -or ($Mode -like 'n') -or ($Mode -like 'q'))

#Block for entering variables in interractive mode
if ($Mode -like 'i')
{
    $fqdn = Read-Host "Type host fqnd"
    $username = Read-Host "Type username"
    $password = Read-Host "Type password" -AsSecureString
}

#Fill block for non-interactive mode
elseif ($Mode -like 'n')
{
    $fqdn = ''
    $username = '' 
    $password = ''
}

else 
{
    Write-Host "Exit"
    Return
}

$domain = $fqdn.TrimStart($fqdn.Split('.')[0]+'.')
$ViewServer = Connect-HVServer -server $fqdn -user $username -password $password -domain $domain
$ViewAPI = $ViewServer.ExtensionData

#Vars for $QueryDefinition object
$MemberType = 'base.name'
$UserOrGroupName = 'RG_ITO_Engineers'

#Loop for role type detection
do
{
$RoleType = Read-Host "Type 'c' for create custom role or 'b' for buitl-in. Type 'q' for Exit"
} until (($RoleType -like 'q') -or ($RoleType -like 'n') -or ($RoleType -like 'q'))

#Vars for $RoleBase object
#Block for custom role
if ($RoleType -like 'c')
{
    $RoleName = 'ITO'
    $RoleDescription = ''
    $RolePrivileges = @('HELPDESK_ADMINISTRATOR_VIEW','MACHINE_MANAGEMENT')
}

#Block for buitl-in role
elseif ($RoleType -like 'b')
{
    $RoleName = 'Help Desk Administrators'

}

else 
{
    Write-Host "Exit"
    Return
}

#Vars for $AccessGroupId object
$AccessGroupName = 'Root'`

#Creating objects
$QueryDefinition = New-Object VMware.Hv.QueryDefinition
$QueryDefinition.queryEntityType = 'ADUserOrGroupSummaryView'
$QueryDefinition.filter = New-Object VMware.Hv.QueryFilterEquals -property @{'memberName'=$MemberType; 'value' =$UserOrGroupName}
$UserOrGroupId=$ViewAPI.QueryService.QueryService_Query($QueryDefinition).Results.Id

#Block for custom role
if ($RoleType -like 'c')
{
    $RoleBase = New-Object VMware.Hv.RoleBase -Property @{name=$RoleName;description=$RoleDescription;privileges=$RolePrivileges}
    $RoleId = $ViewAPI.Role.Role_Create($RoleBase)
}

#Block for buitl-in role
else
{
    $RoleId = ($ViewAPI.Role.Role_List() | Where-Object {$_.Base.Name -like $RoleName}).Id
}

$AccessGroupId=($ViewAPI.AccessGroup.AccessGroup_List() | Where-Object {$_.Base.Name -like $AccessGroupName}).id
$PermissionBase = New-Object VMware.Hv.PermissionBase -Property @{userOrGroup=$UserOrGroupId;role=$RoleId;accessGroup=$AccessGroupId}

#Method call
$ViewAPI.Permission.Permission_Create($PermissionBase)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false
