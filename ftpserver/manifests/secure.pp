class ftpserver::secure (
) inherits ftpserver::params
{

# Windows 2012 R2 and newer required http://technet.microsoft.com/en-us/library/ee662309.aspx
  if $kernelversion =~ /^6\.(1|2|3)/ {
    $sslcert = "New-SelfSignedCertificate -DnsName \$env:computername  -CertStoreLocation cert:\\LocalMachine\\My "
    } else {
    $sslcert ="if (dir cert:\\LocalMachine\My | Select-Object -Property Subject | Where-Object {\$_.Subject -like \"CN=\$env:COMPUTERNAME\"}) {Write-Host \"Cert already exists\"} else {New-SelfSignedCertificate -dnsname \$env:computername -NotAfter (Get-Date).AddMonths(120) -CertStoreLocation cert:\\LocalMachine\\My}"
    }

#new self signed cert using local hostname
#notify { 'secure-self-signed1':}
    exec { 'self-signed':
    command   => "${sslcert}",
    onlyif    => "if (dir cert:\\LocalMachine\My | Select-Object -Property Subject | Where-Object {\$_.Subject -like \"CN=\$env:COMPUTERNAME\"}) { exit 1}",
    logoutput => true,
    provider  => powershell,
    timeout   => 300,
    }

#Set SSL/TLS to Required part one1
#notify { 'secure-ssl-require1':}
-> exec {'ssl-require1':
  command     => "Import-Module WebAdministration; Set-ItemProperty ${ftpsitepath}${sitename} -Name ftpServer.security.ssl.controlChannelPolicy -Value \"SslRequire\"",
  logoutput   => true,
  provider    => powershell,
  subscribe   => Exec['self-signed'],
  refreshonly => true,
  timeout     => 300,
}

#Set SSL/TLS to Required part two
#notify { 'secure-ssl-require2':}
-> exec {'ssl-require2':
  command   => "Set-ItemProperty ${ftpsitepath}${sitename} -Name ftpServer.security.ssl.dataChannelPolicy -Value \"SslRequire\"",
  logoutput => true,
  provider  => powershell,
  subscribe => Exec['self-signed'],
  refreshonly => true,
  timeout   => 300,
}


#Add cert store and Thumbprint part one
#notify { 'secure-ssl-certadd1':}
-> exec {'ssl-certadd1':
  command   => " \$cert= Get-ChildItem Cert:\\LocalMachine\\My | Where-Object {\$_.Subject -like \"CN=\$env:COMPUTERNAME\"}; Set-ItemProperty ${ftpsitepath}${sitename} -Name ftpServer.security.ssl.serverCertStoreName -Value \"My\"; Set-ItemProperty ${ftpsitepath}${sitename} -Name ftpServer.security.ssl.serverCertHash -Value \$cert.Thumbprint",
  onlyif    => "Import-Module WebAdministration; \$cert2 = get-ItemProperty ${ftpsitepath}${sitename} -Name ftpServer.security.ssl.serverCertHash; if (\$cert2.value) {exit 1}",
  logoutput => true,
  provider  => powershell,
  timeout   => 300,
}
  }
