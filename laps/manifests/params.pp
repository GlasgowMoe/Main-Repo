class laps::params {

  $distinguishedname = '(Get-ADDomain).distinguishedname'
  $username           = 'svc_laps'
  $password          = lookup('svc::credentials::laps')

  #$lapsadmin = 'svc_lap'
}
