# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Adding two vCender servers
#   More information in the documentation https://developer.vmware.com/apis/1298/view

#Vars for authorization and mode; Uncomment the desired block
<#
$FQDN = Read-Host "Type host fqnd"
$Domain = Read-Host "Type domain"
$Username = Read-Host "Type username"
$Password = Read-Host "Type password" -AsSecureString

$FQDN = ''
$Domain = ''
$Username = ''
$Password = ''
#>

#Vars for metod

#Vars for metod
#Vars for $QueryDefinition object
$UserOrGroupName = 'Example_group_name'

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Creating $QueryDefinition object 
$QueryDefinition = New-Object VMware.Hv.QueryDefinition
$QueryDefinition.queryEntityType = 'EntitledUserOrGroupLocalSummaryView'
$QueryDefinition.filter = New-Object VMware.Hv.QueryFilterEquals -property @{'memberName'='base.name';'value'=$UserOrGroupName}

#Metod call
#Query UserEntitlementId list
$DesktopUserEntitlements = ($ViewAPI.QueryService.QueryService_Query($QueryDefinition)).Results.LocalData.DesktopUserEntitlements

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false