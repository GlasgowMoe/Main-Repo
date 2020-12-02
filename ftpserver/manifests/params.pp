class ftpserver::params {
$ftpport     = '21'
$ftpsitepath = 'IIS:\\Sites\\'
$basicauth   = 'ftpServer.security.authentication.basicAuthentication.enabled'
$filter      = '/system.ftpServer/security/authorization'
$filter1     = '/system.ftpServer/security/authorization/*'
$roles       = "FTPUsers"
$customer    = $::horus['customer']
#$cert        = "Get-ChildItem Cert:\LocalMachine\My"


if has_key($::horus['tags']['ftpserver'],'dir') {
    $dir = $::horus['tags']['ftpserver']['dir']
    }
# else { $dir = 'C:\FTProot' }

if has_key($::horus['tags']['ftpserver'],'sitename') {
    $sitename = $::horus['tags']['ftpserver']['sitename']
    }

if has_key($::horus['tags']['ftpserver'],'ssl') and $::horus['tags']['ftpserver']['ssl']{
    include ftpserver::secure
    }
}
