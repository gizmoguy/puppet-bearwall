  #
class bearwall (
  $package_ensure   = $bearwall::params::package_ensure,
  $package_provider = $bearwall::params::package_provider,
) inherits bearwall::params {

  validate_string($package_ensure)
  validate_string($package_provider)

  include '::bearwall::install'

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
    -> Anchor['bearwall::end']

}
