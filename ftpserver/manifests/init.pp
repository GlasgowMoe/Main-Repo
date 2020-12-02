#Version 2.0 includes FTP and FTPS support, information on how to use can be found here. https://vtsdocs.vtscloud.io/VCAMP/examples/vcamp-tag-examples under FTPSERVER
class ftpserver ()
{
  anchor { 'ftpserver::begin':; }
  -> class { 'ftpserver::permissions':; }
  -> class { 'ftpserver::install':; }
  -> class { 'ftpserver::config':; }
  -> anchor { 'ftpserver::end':; }
}
