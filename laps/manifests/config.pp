class laps::config ()
inherits laps::params
{

#Directory used to store script
if $facts['role_class'] == 's_ad' {
file { 'C:\temp':
ensure => directory,
  }
}

#Create the account and gets password from Secret
if $facts['role_class'] == 's_ad' {
user {'svc_laps':
  ensure   => present,
  password => $password,
  }
}

#Add the user to Schema admins and Backup Operatiors needed to excute the remote commands 
if $facts['role_class'] == 's_ad' {
exec { 'svc_laps':
    command  =>  'Add-ADGroupMember -Identity "Schema admins" -Members svc_laps;Add-ADGroupMember -Identity "Backup Operators" -Members svc_laps',
    unless   => 'Get-ADGroupMember -Identity "Schema admins" | findstr "svc_laps"',
    provider => 'powershell',
  }
}

#Copies the Schema.ps1 script to the temp dir
if $facts['role_class'] == 's_ad' {
file { 'schmea-powershell-script':
  ensure => present,
  path   => 'C:/temp/schema.ps1',
  source => 'puppet:///modules/laps/schema.ps1',
  }
}
#Copies the GPO policy 
if $facts['role_class'] == 's_ad' {
file { 'copy-xml':
  ensure  => link,
  path    => 'C:/temp/{5E88260C-DAEA-4B1A-989C-4DAA4447264D}',
  source  => 'puppet:///modules/laps/{5E88260C-DAEA-4B1A-989C-4DAA4447264D}',
  recurse => true,
  }
}

#This excutes the schema upgrade needed
if $facts['role_class'] == 's_ad' {
exec { 'erb-script-exec':
    command   => template('laps/powershell.ps1.erb'),
    unless    =>  'if (Get-AdmPwdPassword localhost ) {exit 1}',
    provider  => powershell,
    logoutput => true,
    returns   => [0, 1]
  }
}

# minimise the schedule from running constantly
schedule { 'everyday':
  period => daily,
  range  => '12 - 5',
}

#Enables any new machines in the Computer OU to use LAPS by configuring laps attributes (READ PASSWROD, WRITE PASSWORD)
if $facts['role_class'] == 's_ad' {
exec { 'schema-upgrade':
  command   => "start-process powershell -argument C:\\temp\\shcema.ps1",
  schedule  => 'everyday',
  provider  => powershell,
  logoutput => true,
  }
}

#Creates GPO needed to LAPS
if $facts['role_class'] == 's_ad' {
exec { 'create_gpo':
  command   => "Import-GPO -CreateIfNeeded -path 'C:\\temp\\' -BackupId '{5E88260C-DAEA-4B1A-989C-4DAA4447264D}' -TargetName 'Deploy-LAPS'",
  unless    => 'if (!(get-gpo deploy-laps)) {exit 1}',
  provider  => powershell,
  logoutput => true,
    }
  }

#Links GPO needed for LAPS
if $facts['role_class'] == 's_ad' {
exec { 'link_gpo':
  command     => "new-GPLink -Name Deploy-LAPS -Target $distinguishedname -LinkEnabled Yes -Enforced Yes",
  subscribe   => Exec['create_gpo'],
  refreshonly => true,
  provider    => powershell,
  logoutput   => true,
    }
  }
}
