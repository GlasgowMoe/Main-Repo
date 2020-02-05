class ftpserver ()
{
  anchor { 'ftpserver::begin':; }
  -> class { 'ftpserver::permissions':; }
  -> class { 'ftpserver::install':; }
  -> class { 'ftpserver::config':; }
  -> anchor { 'ftpserver::end':; }
}
