
#Requires -Version 3 -RunAsAdministrator
#Requires -Modules ActiveDirectory, GroupPolicy

[CmdletBinding()]
param ([string[]]$ComputerOU,
	[string[]]$OrgUnitRead,
	[string[]]$OrgUnitReset,
	[string]$SecGroupRead,
	[string]$SecGroupReset,
	[string]$WorkFolderPath = (Join-Path -Path $env:homedrive -ChildPath '\LAPS'),
	[string]$SMBShareName = 'LAPS$',
	[string]$TranscriptFileName = 'Script.log',
	[string]$InstallLogFileName = 'Install.log',
	[string]$GPOName = 'Deploy-LAPS',
	[string]$DownloadURL = 'https://download.microsoft.com/download/C/7/A/C7AAD914-A8A6-4904-88A1-29E657445D03/LAPS.x64.msi',
	[string]$DistributiveFileName = '\LAPS.x64.msi',
  [object]$getwmiobject = (Get-WmiObject -class win32_product),
  [string]$DownloadFolder = "C:\Downloads",
  [string]$DistinguishedName = (Get-ADDomain).DistinguishedName
 )  

# Find NetBIOS and FQDN names of the domain.
$NetBIOSName = (Get-ADDomain).NetBIOSName
$FQDN = (Get-ADDomain).DNSRoot

<# https://blogs.msdn.microsoft.com/powershell/2007/06/19/get-scriptdirectory-to-the-rescue/
function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}
$DownloadFolder = Get-ScriptDirectory

# DemoScript.ps1
$DownloadFolder = $PSScriptRoor + "\Test"
Write-Host $DownloadFolder#>

IF (-not $SMBShareName)
{
	New-Item -Path $WorkFolderPath -ItemType Directory -Force
}

# Start a transcipt of the script.
Start-Transcript -Path (Join-Path -Path $WorkFolderPath -ChildPath $TranscriptFileName)

# Create a share on the DC for the software. Add read access for domain computers to the share.
if (-NOT (get-smbshare $SMBShareName))
    {
     New-SmbShare -Name $SMBShareName -Path $WorkFolderPath -ReadAccess "$NetBIOSName\Domain Computers" -FullAccess "$NetBIOSName\Domain Admins"
  } 


#Copy files
if (!(Test-Path -path $WorkFolderPath)) {Copy-Item $DownloadFolder -Destination $WorkFolderPath -Recurse -Force}


#Download and install MS LAPS software.

$InstallationFilePath = (Join-Path -Path $WorkFolderPath -ChildPath $DistributiveFileName)
Invoke-WebRequest -Uri $DownloadURL -OutFile $InstallationFilePath

$MSIArguments = @(
  "/i $InstallationFilePath",
  "ADDLOCAL=ALL /quiet"
)

$software = "Local Administrator Password Solution";
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software }) -ne $null

If(-Not $installed) {
	start-process -FilePath msiexec.exe  -ArgumentList $MSIArguments -Wait
} else {
	Write-Host "'$software' is installed."
}

Start-Sleep -s 10

# Import required PowerShell cmdlet.
# Update AD schema to accomodate the new fields to store password data.
Import-Module -Name AdmPwd.PS
Update-AdmPwdADSchema

# Check if a computer OU was provided by the parameter and act accordingly.
if (!$ComputerOU)
{
	# Get the default computer OU.
	# Reference https://support.microsoft.com/en-us/kb/324949
	$OUQuery = [adsisearcher]'(&(objectclass=domain))'
	$OUQuery.SearchScope = 'base'
	$OUQuery.FindOne().properties.wellknownobjects | ForEach-Object {
		if ($_ -match '^B:32:AA312825768811D1ADED00C04FD8D5CD:(.*)$')
		{
			$ComputerOU = $Matches[1]
			Write-host $ComputerOU
		}
	}
}
foreach ($OrgUnit in $ComputerOU)
{
	Set-AdmPwdComputerSelfPermission -Identity $OrgUnit
}

# Configure who can read the password. By default only domain/enterprise admins can.
if (!$OrgUnitRead)
{
	$OrgUnitRead = $ComputerOU
}
if ($SecGroupRead) {
	foreach ($OrgUnit in $OrgUnitRead)
	{
		Set-AdmPwdReadPasswordPermission -Identity $OrgUnit -AllowedPrincipals $SecGroupRead
	}
}

# Configure who can force a password change. By default only domain/enterprise admins can.
if (!$OrgUnitReset)
{
	$OrgUnitReset = $ComputerOU
}
if ($SecGroupReset) {
	foreach ($OrgUnit in $OrgUnitReset)
	{
		Set-AdmPwdResetPasswordPermission -Identity $OrgUnit -AllowedPrincipals $SecGroupReset
	}
}


# Importing the GPO
# Reference https://gallery.technet.microsoft.com/Migrate-Group-Policy-2b5067d8#content
Set-Location -Path $WorkFolderPath
Import-Module -Name GroupPolicy
Import-Module -Name ActiveDirectory

# Change variables in the GPO migration table to suit environment by recursing through the migration table and then changing the values to suit the current environment.
#$MigrationTable =  "$WorkFolderPath\MyTable.migtable"
#(Get-Content $MigrationTable).replace("FQDN", "$FQDN") | Set-Content $MigrationTable
#(Get-Content $MigrationTable).replace("NETBIOS", "$NetBIOSName") | Set-Content $MigrationTable
#(Get-Content $MigrationTable).replace("DOMAINCONTROLLER", "$env:computername") | Set-Content $MigrationTable
#(Get-Content $MigrationTable).replace("COMPUTER", "$env:computername") | Set-Content $MigrationTable
#(Get-Content $MigrationTable).replace("ADMIN", "$env:username") | Set-Content $MigrationTable
#(Get-Content $MigrationTable).replace("\\UNCPath", "\\$env:computername") | Set-Content $MigrationTable
#(Get-Content C:\Shadow\LAPS\test.txt).Replace("blue", "red") | Set-Content C:\Shadow\LAPS\test.txt
#((Get-Content -path C:\Shadow\LAPS\test.txt -Raw) -replace 'Blue','white') | Set-Content -Path C:\Shadow\LAPS\test.txt 
#((Get-Content -path $MigrationTable -raw) -replace "FQDN", "$FQDN") | Set-Content $MigrationTable
#(Get-content -path $MigrationTable).Replace("\\ReplaceDestinationWithPath","\\server2019\laps$") | Set-Content $MigrationTable


 #Import the actual GPO            
 Import-GPO -CreateIfNeeded -path "$WorkFolderPath" -BackupId '{8289D57F-B37C-41E0-A4E5-712B60B34DA8}' -TargetName $GPOName -MigrationTable $MigrationTable 
 new-GPLink -Name $GPOName -Target $DistinguishedName -LinkEnabled Yes -Enforced Yes
 Stop-Transcript
