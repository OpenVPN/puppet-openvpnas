# @summary install OpenVPN Access Server
#
# Install OpenVPN Access Server from the official repositories
#
class openvpnas::install {
  case $facts['os']['family'] {
    'Debian': {
      ::apt::source { 'as-repository':
        comment  => 'Official OpenVPN Access Server repository',
        location => 'http://as-repository.openvpn.net/as/debian',
        release  => $facts['os']['distro']['codename'],
        repos    => 'main',
        key      => {
          'id'     => '8B1BC7FECB7259E1430A3AA026EB39123AAAAA96',
          'source' => 'https://as-repository.openvpn.net/as-repo-public.gpg',
        },
        include  => {
          'deb' => true,
        },
      }

      package { 'openvpn-as':
        ensure  => $openvpnas::package_ensure,
        require => Apt::Source['as-repository'],
      }
    }
    'RedHat': {
      package { 'openvpn-as-yum':
        ensure => $openvpnas::package_ensure,
        source => "https://as-repository.openvpn.net/as-repo-centos${facts['os']['release']['major']}.rpm",
      }

      package { 'openvpn-as':
        ensure  => $openvpnas::package_ensure,
        require => Package['openvpn-as-yum'],
      }
    }
    default: {
      fail('ERROR: unknown OS distro!')
    }
  }
}
