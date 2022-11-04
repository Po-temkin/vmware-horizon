# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Creating user or group entitlement for specific desktop
#   More information in the documentation https://developer.vmware.com/apis/1298/view

#Vars for authorization; Uncomment the desired block
<#
$FQDN = Read-Host "Type host fqnd"
$Domain = Read-Host "Type domain"
$Username = Read-Host "Type username"
$Password = Read-Host "Type password" -AsSecureString
$ICAPassword = Read-Host "Type ICA password" -AsSecureString 
#>

<#
$FQDN = ''
$Domain = ''
$Username = ''
$Password = ''
#>

#Vars for metod
#Vars for $QueryDefinition object
$UserOrGroupName = ''

#Opening API session
$ViewServer = Connect-HVServer -server $fqdn -user $user -password $pass -domain $domain
$ViewAPI = $ViewServer.ExtensionData

#Querying user or group id
$QueryDefinition = New-Object VMware.Hv.QueryDefinition
$QueryDefinition.queryEntityType = 'ADUserOrGroupSummaryView'
$QueryDefinition.filter = New-Object VMware.Hv.QueryFilterEquals -property @{'memberName'='base.name'; 'value' = $UserOrGroupName}
$UserOrGroupId = $ViewAPI.QueryService.QueryService_Query($QueryDefinition).Results.Id

#Use horizon_view_api_query_desktop.ps1 to get $DesktopSummaryData
$DesktopId = $DesktopSummaryData.Results.Id
$UserEntitlementBase = New-Object VMware.Hv.UserEntitlementBase -Property @{userOrGroup=$UserOrGroupId;resource=$DesktopId}

#Method call
$ViewAPI.UserEntitlement.UserEntitlement_Create($UserEntitlementBase)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false