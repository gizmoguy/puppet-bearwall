define bearwall_interface ($policies, $if_features) {

  file { "${name}.if":
    ensure  => file,
    path    => "${bearwall::interfaces_dir}/${name}.if",
    content => template($bearwall::interfaces_config),
    owner   => '0',
    group   => '0',
    mode    => '0644'
  }

}

class bearwall::config {

  $interfaces = $bearwall::interfaces

  create_resources(bearwall_interface, $interfaces)

}
