  #
class bearwall (
  $package_ensure    = $bearwall::params::package_ensure,
  $package_provider  = $bearwall::params::package_provider,
  $interfaces        = $bearwall::params::interfaces,
  $interfaces_dir    = $bearwall::params::interfaces_dir,
  $interfaces_config = $bearwall::params::interfaces_config,
) inherits bearwall::params {

  validate_string($package_ensure)
  validate_string($package_provider)
  validate_hash($interfaces)
  validate_string($interfaces_config)
  validate_absolute_path($interfaces_dir)

  include '::bearwall::install'
  include '::bearwall::config'

  case $::osfamily {
    'Debian':
      { include '::bearwall::repo::apt' }
    default:
      { }
  }

  # Anchor this as per #8040 - this ensures that classes won't float off and
  # mess everything up.  You can read about this at:
  # http://docs.puppetlabs.com/puppet/2.7/reference/lang_containment.html#known-issues
  anchor { 'bearwall::begin': }
  anchor { 'bearwall::end': }

  Anchor['bearwall::begin'] -> Class['::bearwall::install']
    -> Class['bearwall::config'] -> Anchor['bearwall::end']

}
