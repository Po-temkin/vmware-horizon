# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Deliting desktop using its id
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

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password  -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Use horizon_view_api_query_desktop.ps1 to get $DesktopSummaryData
$DesktopId = $DesktopSummaryData.Results.Id

#Metod call
$ViewAPI.Desktop.Desktop_Delete($DesktopId,$null)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false

