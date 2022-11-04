# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Setting Horizon license key
#   More information in the documentation https://developer.vmware.com/apis/1298/view


#Vars for authorization; Uncomment the desired block
<#
$FQDN = Read-Host "Type host fqnd"
$Domain = Read-Host "Type domain"
$Username = Read-Host "Type username"
$Password = Read-Host "Type password" -AsSecureString
#>

<#
$FQDN = ''
$Domain = ''
$Username = ''
$Password = ''
#>

#Vars for metod
$LicenseKey = 'XXXXX-XXXXX-XXXXX-XXXXX-XXXXX' #

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Method call
$ViewAPI.License.License_Set($LicenseKey)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false