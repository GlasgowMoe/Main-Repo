class ftpserver::permissions ()
{
#Create FTP USER
user {'FTP USER':
  ensure   => present,
  password => Sensitive("Password1"),
  comment  => "FTP USER1"
}
#Create FTP USERS group and add FTP USER to this group
group { 'FTP USERS':
  name    => 'FTP USERS',
  ensure  => present,
  members => ['FTP USER'],
  auth_membership => false,
}
file { 'C:\FTProot':
  nsure => 'directory',
  owner  => 'FTP USER',
  group  => 'FTP USERS',
  mode   => '0777',
  recurse => true,
  }
}
