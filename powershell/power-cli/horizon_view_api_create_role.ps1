# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Creating administrator role for user or group
#   Use $RoleType flag to choose custom or buitl-in role
#   More information in the documentation https://developer.vmware.com/apis/1298/view

#Vars for authorization and mode; Uncomment the desired block
<#
$FQDN = Read-Host "Type host fqnd"
$Domain = Read-Host "Type domain"
$Username = Read-Host "Type username"
$Password = Read-Host "Type password" -AsSecureString
$RoleType  = Read-Host "Type 'c' for create custom role"

$FQDN = ''
$Domain = ''
$Username = ''
$Password = ''
$RoleType = ''
#>

#Vars for metod
#Vars for $QueryDefinition object
$UserOrGroupName = ''

#Vars for $AccessGroupId object
$AccessGroupName = 'Root'

#Vars for $RoleBase object
$RoleName = 'Examle_role_name'
$RoleDescription = ''
$RolePrivileges = @('HELPDESK_ADMINISTRATOR_VIEW','MACHINE_MANAGEMENT')

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Creating objects
$QueryDefinition = New-Object VMware.Hv.QueryDefinition
$QueryDefinition.queryEntityType = 'ADUserOrGroupSummaryView'
$QueryDefinition.filter = New-Object VMware.Hv.QueryFilterEquals -property @{'memberName'='base.name'; 'value' =$UserOrGroupName}
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
