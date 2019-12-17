# @summary install OpenVPN Access Server
#
# Install OpenVPN Access Server from the official repositories
#
class openvpnas::install {

  case $::osfamily {
    'Debian': {
      ::apt::source { 'as-repository':
        comment  => 'Official OpenVPN Access Server repository',
        location => 'http://as-repository.openvpn.net/as/debian',
        release  => $::lsbdistcodename,
        repos    => 'main',
        key      => {
          'id'     => '8B1BC7FECB7259E1430A3AA026EB39123AAAAA96',
          'source' => 'https://as-repository.openvpn.net/as-repo-public.gpg',
        },
        include  => {
          'deb' => true,
        }
      }

      package { 'openvpn-as':
        ensure  => 'present',
        require => Apt::Source['as-repository'],
      }
    }
  }
}
