class ftpserver::config (
  $ftpsitepath = 'IIS:\\Sites\\',
  $basicauth   = 'ftpServer.security.authentication.basicAuthentication.enabled',
  $roles       = '"FTP USERS"',
  $pspath      =  'Automated-FTP-Site',
  $filter      = '/system.ftpServer/security/authorization',
  $filter1     = '/system.ftpServer/security/authorization/*',
)
{
#Enable basic authenctication on the FTP site. XXXXX----XXXXXX--
exec { 'basic-authentication':
  command     => "Import-Module WebAdministration; Set-ItemProperty -Path ${ftpsitepath}${pspath} -Name ${basicauth} -Value True",
  onlyif      =>  
  refreshonly => true,
  provider    => powershell,
  logoutput   =>  true,
  timeout     => 300,
}

# Add an authorization read rule for FTP Users.
exec {'group-authorization':
  command   => "Add-WebConfiguration -Filter ${filter} -Value @{accessType=\"Allow\"; roles=${roles}; permissions=\"Read, Write\"} -PSPath IIS:\\ -Location ${pspath} ",
  unless    =>"if (@(Get-WebConfiguration ${filter1} -Recurse | where {\$_.roles -match ${roles}}).count -eq 0) {exit 1}",
  notify    => Exec['basic-authentication'],
  #logoutput => true,
  provider  => powershell,
  timeout   => 300,
  }
}
