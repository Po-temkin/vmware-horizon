# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Adding instant clone domain account
#   More information in the documentation https://developer.vmware.com/apis/1298/view

#Vars for authorization; Uncomment the desired block
<#
$FQDN = Read-Host "Type host fqnd"
$Domain = Read-Host "Type domain"
$Username = Read-Host "Type username"
$Password = Read-Host "Type password" -AsSecureString
$ICAPassword = Read-Host "Type ICA password" -AsSecureString 

$FQDN = ''
$Domain = ''
$Username = ''
$Password = ''
#>

#Vars for metod
#Vars for $ICAPasswordENC object
$ICAPasswordPlain = 'qwerty123456'

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $Username -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Used for determine domain id if used more than one domain
$ICADomain = $Domain

#Vars for $InstantCloneEngineDomainAdministratorBase object

$ADDomainId = (($ViewAPI.ADDomain.ADDomain_list() | Where-Object {$_.DnsName -eq $ICADomain} | Select-Object -first 1).id)

#Uncomment if $ICAPassword taken from input
<#
$ICAPasswordTemp = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($ICAPassword)
$ICAPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ICAPasswordTemp)
#>

#Encripting password
$ICAPasswordENC = New-Object VMware.Hv.SecureString
$ENC = [system.Text.Encoding]::UTF8
$ICAPasswordENC.Utf8String = $ENC.GetBytes($ICAPasswordPlain)

#Creating objects
$InstantCloneEngineDomainAdministratorBase = New-Object VMware.Hv.InstantCloneEngineDomainAdministratorBase -Property @{domain=$ADDomainId;userName=$ICAUsername;password=$ICAPasswordENC}
$InstantCloneEngineDomainAdministratorSpec = New-Object VMware.Hv.InstantCloneEngineDomainAdministratorSpec -Property @{base=$InstantCloneEngineDomainAdministratorBase}

#Method call
$ViewAPI.InstantCloneEngineDomainAdministrator.InstantCloneEngineDomainAdministrator_Create($InstantCloneEngineDomainAdministratorSpec)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false
