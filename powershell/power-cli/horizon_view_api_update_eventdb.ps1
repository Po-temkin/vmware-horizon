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
$SQLServerPassword = Read-Host "Type SQL password" -AsSecureString

$FQDN = ''
$Domain = ''
$Username = ''
$Password = ''
#>

#Vars for metod
#Vars for $SQLServerPasswordENC object
$SQLServerPasswordPlain = 'qwerty123456'

#Vars for $EventDatabaseSettings object
$SQLServerName = 'sql.domain.com'
$SQLType = 'SQLSERVER'
$SQLServerPort = '1433'
$SQLServerDB = 'horizon_event'
$SQLServerUsername = 'sqluser'
$SQLServerPasswordPlain = 'qwerty123456'
$SQLServerTablePrefix = 'HRZ_'

#Vars for $EventDatabaseEventSettings
$EventsTime = 'ONE_WEEK'
$EventsNew = 1

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Uncomment if $ICAPassword taken from input
<#
$ICAPasswordTemp = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ICAPassword)
$ICAPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ICAPasswordTemp)
#>

#Encripting password
$SQLServerPasswordENC = New-Object VMware.Hv.SecureString
$ENC = [system.Text.Encoding]::UTF8
$sqlpassenc.Utf8String = $enc.GetBytes($SQLServerPasswordPlain)

#Creating objects
$EventDatabaseSettings = New-Object VMware.Hv.EventDatabaseSettings -Property @{server=$SQLServerName;type=$SQLType;port=$SQLServerPort;name=$SQLServerDB;userName=$SQLServerUsername;password=$SQLServerPasswordENC;tablePrefix=$SQLServerTablePrefix}
$EventDatabaseEventSettings = New-Object VMware.Hv.EventDatabaseEventSettings -Property @{showEventsForTime=$EventsTime;classifyEventsAsNewForDays=$EventsNew}
$MapEntry1 = New-Object VMware.Hv.MapEntry -Property @{Key='eventDatabaseSet';Value=$true}
$MapEntry2 = New-Object VMware.Hv.MapEntry -Property @{Key='database';Value=$EventDatabaseSettings}
$MapEntry3 = New-Object VMware.Hv.MapEntry -Property @{Key='settings';Value=$EventDatabaseEventSettings}
$MapEntry = @($MapEntry1,$MapEntry2,$MapEntry3)

#Method call
$ViewAPI.EventDatabase.EventDatabase_Update($MapEntry)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false