class ftpserver ()
{
if $facts['os']['name'] == 'Windows'{
include ftpserver::install
  }
}
