class ftpserver::permissions ()
inherits ftpserver::params
{

file { $dir:
  ensure  => 'directory',
  group   => ["${::customer}\\${::roles}", 'NT SERVICE\TrustedInstaller'],
  mode    => '0770',
  recurse => true,
  }
}
