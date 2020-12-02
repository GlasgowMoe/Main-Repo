
# Import required PowerShell cmdlet.
# Update AD schema to accomodate the new fields to store password data.
# Import-Module -Name AdmPwd.PS
# Update-AdmPwdADSchema - moved to Template

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