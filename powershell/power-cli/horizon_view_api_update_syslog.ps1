# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Updating syslog settings
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
#Vars for $SyslogFileData object
$FileLogEnabled = $false
$FileLogOnError = $false

#Vars for $SyslogUDPData
$UDPLogEnabeled = $true
$SyslogServerAddress = @('192.168.1.1.')

#Opening API session
$ViewServer = Connect-HVServer -server $fqdn -user $username -password $password -domain $domain
$ViewAPI = $ViewServer.ExtensionData

#Creating objects
$SyslogFileData = New-Object VMware.Hv.SyslogFileData -Property @{enabled=$FileLogEnabled;enabledOnError=$FileLogOnError}
$SyslogUDPData = New-Object VMware.Hv.SyslogUDPData -Property @{enabled=$UDPLogEnabeled;networkAddresses=$SyslogServerAddress}
$MapEntry1 = New-Object VMware.Hv.MapEntry -Property @{Key='fileData';Value=$SyslogFileData}
$MapEntry2 = New-Object VMware.Hv.MapEntry -Property @{Key='udpData';Value=$SyslogUDPData}
$MapEntry = @($MapEntry1,$MapEntry2)

#Method call
$ViewAPI.Syslog.Syslog_Update($MapEntry)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false