# Sctipted by:
#   Po-temkin
#
# Tested on:
#   PowerCLI: 12.7
#   Horizon: 2203
#
# Desctiption:
#   Adding two vCenter servers
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
#Vars for $ServerSpec object
$VCServerName1 = 'vcs01.domain.com'
$VCServerName2 = 'vcs02.domain.com'
$VCPort = '443'
$UseSSL = $true
$VCUsername = 'vcadmin' 
$VCPasswordPlain = 'qwerty12345'
$VCType = 'VIRTUAL_CENTER'

#Vars for $VirtualCenterConcurrentOperationLimits object
$VCProvisionLimit = '20'
$VCPowerOperationLimit = '50'
$ComposerMaintenanceLimit ='12'
$ICEProvisionLimit = '20'

#Vars for $VirtualCenterStorageAcceleratorData object
$VCStorageADEnabled = $true
$VCStorageADCache = '1024'

#Vars for $VirtualCenterSpec object
$VCDescription = ''
$VCDisplayName = ''
$seSparceEbabled = $false
$VCDeploymentType = 'GENERAL'

#Opening API session
$ViewServer = Connect-HVServer -server $FQDN -user $User -password $Password -domain $Domain
$ViewAPI = $ViewServer.ExtensionData

#Uncomment if $VCPassword taken from input
<#
$VCPasswordTemp = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($VCPassword)
$VCPasswordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($ICAPasswordTemp)
#>

#Encripting password
$VCPasswordENC = New-Object VMware.Hv.SecureString
$ENC = [system.Text.Encoding]::UTF8
$VCPasswordENC.Utf8String = $enc.GetBytes($VCPasswordPlain)

#Creating objects
#Creating $ServerSpec object
$ServerSpec = New-Object VMware.Hv.ServerSpec -Property @{serverName=$VCServerName1;port=$VCPort;useSSL=$UseSSL;userName=$VCUsername;password=$VCPasswordENC;serverType=$VCType}

#Creating $VirtualCenterConcurrentOperationLimits object
$VirtualCenterConcurrentOperationLimits = New-Object VMware.Hv.VirtualCenterConcurrentOperationLimits -Property @{
vcProvisioningLimit=$VCProvisionLimit;
vcPowerOperationsLimit=$VCPowerOperationLimit;
viewComposerMaintenanceLimit=$ComposerMaintenanceLimit;
instantCloneEngineProvisioningLimit=$ICEProvisionLimit
}

#Creating $VirtualCenterStorageAcceleratorData object
$VirtualCenterStorageAcceleratorData = New-Object VMware.Hv.VirtualCenterStorageAcceleratorData -Property @{enabled=$VCStorageADEnabled;defaultCacheSizeMB=$VCStorageADCache}

#Creating $VirtualCenterSpec object
$VirtualCenterSpec = New-Object VMware.Hv.VirtualCenterSpec -Property @{
serverSpec=$ServerSpec;
description=$VCDescription;
displayName=$VCDisplayName;
limits=$VirtualCenterConcurrentOperationLimits;
storageAcceleratorData=$VirtualCenterStorageAcceleratorData;
seSparseReclamationEnabled=$seSparceEbabled;
deploymentType=$VCDeploymentType
}

#Method call for first VC
$ViewAPI.VirtualCenter.VirtualCenter_Create($VirtualCenterSpec)

#Changing VC name
$ServerSpec.serverName = $VCServerName2

#Method call for second VC
$ViewAPI.VirtualCenter.VirtualCenter_Create($VirtualCenterSpec)

#Closing API session
Disconnect-HVServer -Force $ViewServer -Confirm:$false