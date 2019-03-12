class moetest::fixdisk {
      if $osfamily == 'windows' {
            $file_path = 'disk.ps1'
            $powershellexe = 'C:/Windows/System32/WindowsPowerShell/v1.0/powershell.exe'
            $script_path = "C:/Windows/Temp/${file_path}"

            file { 'fixingthedisks':
                  path => $script_path,
                  ensure => "file",
                  source => "puppet:///files/$file_pathop"
            } ->
            exec { 'disk':
                  command => "start-process -verb runas $powershellexe -argumentlist '-file ${script_path}'",
                  provider => "powershell"
            }
      }
}