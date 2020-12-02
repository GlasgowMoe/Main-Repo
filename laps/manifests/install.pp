class laps::install (
  ) inherits laps::params
{
#Install's Full LAPS on AD servers and dll files on domain members
if $::facts['os']['family'] == 'windows'{
  # this is windows (and not linux!)
  if $::facts['v_is_domaincontroller'] {
      package { 'laps':
      ensure          => latest,
      provider        => 'chocolatey',
      install_options => ['--params','/ALL'],
    }
  } else {
      package {'laps':
      ensure   => latest,
      provider => 'chocolatey',
    }
  }
  }
}

