# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Querying information about one or all desktops
#   More information in the documentation https://developer.vmware.com/apis/1298/view

#Vars for authorization and mode; Uncomment the desired block
<#
$FQDN = Read-Host "Type host fqnd"
$Domain = Read-Host "Type domain"
$Username = Read-Host "Type username"
$Password = Read-Host "Type password" -AsSecureString
$Mode = Read-Host "Type 'n' for poolname-mode. Otherwise, all pools will be queried"

$FQDN = ''
$Domain = ''
$Username = ''
$Password = ''
$Mode = 'n'
#>

#Vars for metod
#Vars for $QueryDefinition object
$DesktopName = 'desc-tst'

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Querying named pool
if ($Mode -like 'n')
{
$QueryDefinition = New-Object VMware.Hv.QueryDefinition
$QueryDefinition.queryEntityType = 'DesktopSummaryView'
$QueryDefinition.filter = New-Object VMware.Hv.QueryFilterEquals -Property @{'memberName'='desktopSummaryData.name';'value'=$DesktopName}
$DesktopSummaryData = ($ViewAPI.QueryService.QueryService_Query($QueryDefinition)).Results
$DesktopSummaryData
}

#Querying all pools
else
{
$QueryDefinition = New-Object VMware.Hv.QueryDefinition
$QueryDefinition.queryEntityType = 'DesktopSummaryView'
$DesktopSummaryData = ($ViewAPI.QueryService.QueryService_Query($QueryDefinition)).Results
$DesktopSummaryData
}