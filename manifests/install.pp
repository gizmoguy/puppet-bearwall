class bearwall::install {

  $package_ensure   = $bearwall::package_ensure
  $package_provider = $bearwall::package_provider

  package { 'bearwall':
    ensure   => $package_ensure,
    name     => 'bearwall',
    provider => $package_provider
  }

}
