#This class is used by Windows local admin password tool to reset the Administrtor password using group ploicy. 
class laps ()
{
  anchor { 'laps::begin':; }
  -> class { 'laps::install':; }
  -> class { 'laps::config':; }
  -> anchor { 'laps::end':; }
}
