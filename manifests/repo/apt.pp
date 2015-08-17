# requires
#   puppetlabs-apt
class bearwall::repo::apt {

  Class['bearwall::repo::apt'] -> Package<| title == 'bearwall' |>

  apt::source { 'bearwall-repo':
    location    => 'http://packages.bearwall.org/',
    release     => $::lsbdistcodename,
    repos       => 'main',
    include_src => false,
    key         => '6ABA09963E518866C29FA6C10F0921E4A2D0D6AE',
    key_content => template('bearwall/repo.pub.key.erb'),
  }
}
