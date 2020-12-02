$username = "svc_laps"
$password =  lookup("svc::credentials::laps")
$credentials = New-Object System.Management.Automation.PSCredential -ArgumentList @($username,(ConvertTo-SecureString -String $password -AsPlainText -Force))
