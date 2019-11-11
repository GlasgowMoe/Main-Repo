 if $::kernelversion =~ /^(6.1)/ {
    $install_role = 'Add-WindowsFeature'
    } else {
      $import_module = 'Import-Module WebAdministration'
    }
