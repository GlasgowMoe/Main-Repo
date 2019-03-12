class moetest {

$software = ['adobereader','googlechrome']
package { $software:
  provider  => 'chocolatey',
  ensure    => 'installed'
}
file {'C:/temp1.bat':
  ensure  => present,
  content => "cmd logoff",
}
  }