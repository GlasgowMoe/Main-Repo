class ftpserver::install (
  # $ftpsitename = 'Automated Ftp Site',
  # $ftprootdir  = 'C:\FTProot',
  # $ftpport     = '21',
) {
  $ftpsitename = 'Automated Ftp Site'
  $ftprootdir  = 'C:\FTProot'
  $ftpport     = '21'

  # Windows 2008 R2 and newer required http://technet.microsoft.com/en-us/library/ee662309.aspx
  if $::kernelversion !~ /^(10|6\.(1|2|3))/ { fail ('FTP Server module requires Windows 2008 R2 or newer') }

  # from Windows 2012 'Add-Windowsrole' has been replaced with 'Install-Windowsrole' http://technet.microsoft.com/en-us/library/ee662309.aspx
  if $::kernelversion =~ /^(6.1)/ {
    $install_role = 'Add-WindowsFeature'
    } else {
      $install_role = 'Install-WindowsFeature'
    }
  # Install FTS-Server Role & Import Web Administration
  if ($install_role) {
    exec { 'install_role':
    command  => "${install_role} Web-FTP-Server -IncludeAllSubFeature -IncludeManagementTools",
    onlyif   => "if (@(Get-WindowsFeature 'web-FTP-Server' | ?{\$_.Installed -match \'true\'}).count -eq 0)  { exit 1 } ",
    provider => powershell,
    timeout  => 300,
  }
  -> exec { 'import_webadmin':
    command  => 'Import-Module WebAdministration',
    provider => powershell,
    timeout  => 300,
  }
    file {'C:\FTProot':
      ensure  => directory,
  }
    exec {  'create_ftp_site':
      command  => "New-WebFtpSite -Name 'Automated FTP Site' -Port ${ftpport} -PhysicalPath 'C:\FTProot' -IPAddress '*' -Force",
      provider => powershell,
      timeout  => 300,
      onlyif   =>  File['C:\FTProot'],
   }
  }
}



