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
#$DesktopSummaryData #Use horizon_view_api_query_desktop.ps1 to get it 
#$DesktopUserEntitlements @Use horizon_view_api_delete_desktop_entitlement.ps1 to get it

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Serching desired pair
ForEach ($DesktopUserEntitlement in $DesktopUserEntitlements)
{
    $UserEntitlementInfo = $ViewAPI.UserEntitlement.UserEntitlement_Get($DesktopUserEntitlement)
    if ($UserEntitlementInfo.Base.Resource.Id -eq $DesktopSummaryData.Results.Id) 
    {
        $UserEntitlementId = $DesktopUserEntitlement
        $UserEntitlementId
    }
}

#Method call
$ViewAPI.UserEntitlement.UserEntitlement_Delete($UserEntitlementId)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false