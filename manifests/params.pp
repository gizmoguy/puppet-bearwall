  # Class: bearwall::params
#
#   The bearwall configuration settings.
#
class bearwall::params {

  case $::osfamily {
    'Debian': {
      $package_ensure   = 'installed'
      $package_provider = 'apt'
      $interfaces_dir   = '/etc/bearwall/interfaces.d'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.")
    }
  }

  $interfaces        = {}
  $interfaces_config = 'bearwall/if.erb'

}
