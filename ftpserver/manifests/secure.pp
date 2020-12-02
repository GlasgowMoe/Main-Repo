#New Self signed cert
New-SelfSignedCertificate -dnsname $env:computername -NotAfter (Get-Date).AddMonths(120) -CertStoreLocation cert:\LocalMachine\My


(dir cert: -Recurse | Where-Object { $_.Subject -like "*$env:computername*" })




# set SSL/TLS required
Import-Module WebAdministration
Set-ItemProperty "IIS:\Sites\Automated-FTP" -Name ftpServer.security.ssl.controlChannelPolicy -Value "SslRequire" 
Set-ItemProperty "IIS:\Sites\Automated-FTP" -Name ftpServer.security.ssl.dataChannelPolicy -Value "SslRequire" 

# confirm Thumbprint of certificate
$cert = Get-ChildItem Cert:\LocalMachine\My | Where-Object {$_.Subject -like "*$env:computername"} 


# add cert store and Thumbprint
Set-ItemProperty "IIS:\Sites\Automated-FTP" -Name ftpServer.security.ssl.serverCertStoreName -Value "My" 
Set-ItemProperty "IIS:\Sites\Automated-FTP" -Name ftpServer.security.ssl.serverCertHash -Value $cert.Thumbprint





