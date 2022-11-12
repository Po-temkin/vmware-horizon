# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Updating global policies
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
#Vars for $MapEntry objects
$MultimediaRedirection = 'Deny'
$USBAccess = 'Allow'
$RemoteMode = 'Allow'
$PCoIPHardwareAcceleration = 'Deny' 
$HardwareAccelerationPriority = $null

#Opening API session
$ViewServer = Connect-HVServer -server $fqdn -user $username -password $password -domain $domain
$ViewAPI = $ViewServer.ExtensionData

#Creating objects
$MapEntry1 = New-Object VMware.Hv.MapEntry -Property @{Key='allowMultimediaRedirection';Value=$MultimediaRedirection}
$MapEntry2 = New-Object VMware.Hv.MapEntry -Property @{Key='allowUSBAccess';Value=$USBAccess}
$MapEntry3 = New-Object VMware.Hv.MapEntry -Property @{Key='allowRemoteMode';Value=$RemoteMode}
$MapEntry4 = New-Object VMware.Hv.MapEntry -Property @{Key='allowPCoIPHardwareAcceleration';Value=$PCoIPHardwareAcceleration}
$MapEntry5 = New-Object VMware.Hv.MapEntry -Property @{Key='pcoipHardwareAccelerationPriority';Value=$HardwareAccelerationPriority}
$MapEntry = @($MapEntry1,$MapEntry2,$MapEntry3,$MapEntry4,$MapEntry5)

#Method call
$ViewAPI.Policies.Policies_Update($null,$null,$MapEntry)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false
