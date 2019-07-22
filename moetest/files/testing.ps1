param (
        
    [string]$username = $(Read-Host -asSecureString "username is required."),
    [string]$password = $(Read-Host -asSecureString "Input password" ),
    [switch]$SaveData = $false
)
write-output "The price is $price"
write-output "The Computer Name is $ComputerName"
write-output "The True/False switch argument is $SaveData"

throw "This is an error."

function Get-XMLFiles
{
  param ($path = $(throw "The Path parameter is required."))
  dir -path $path\*.xml -recurse |
    sort lastwritetime |
      ft lastwritetime, attributes, name  -auto
}

function Test-Param{
	[CmdletBinding()]
		Param(
			[ValidateSet('Admin1','Admin2','Admin3')]
			[Parameter(
				Mandatory=$True,
				HelpMessage="Please enter the SQL sysadmin username",
				Position=1
			)][string]$SQLUsername
		)
}

Test-Admin -SQLUsername <tab>