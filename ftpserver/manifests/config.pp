class ftpserver::config (
) inherits ftpserver::params
{
#notify { 'config':}

#Add an authorization read rule for FTP Users.
  exec { 'group-authorization':
    command   => "Import-Module WebAdministration; Add-WebConfiguration -Filter ${filter} -Value @{accessType=\"Allow\"; roles=\"${customer}\\${roles}\"; permissions=\"Read, Write\"} -PSPath IIS:\\\ -Location ${sitename}",
    onlyif    =>" if (Get-WebConfiguration '/system.ftpServer/security/authorization/*' -Recurse | where {\$_ -ne \$null}) { exit 1 }",
    logoutput => true,
    provider  => powershell,
    timeout   => 300,
    }


#Enable basic authenctication on the FTP site.
  exec { 'basic-authentication':
    command     => "Import-Module WebAdministration; Set-ItemProperty -Path ${ftpsitepath}${sitename} -Name ${basicauth} -Value True",
    onlyif      =>  "if (Get-ItemProperty -Path ${ftpsitepath}${sitename} -Name ${basicauth} | where {\$_.Value -ne \$false}) { exit 1 }",
    provider    => powershell,
    logoutput   =>  true,
    timeout     => 300,
    }
  }
