# @summary setup OpenVPN Access Server
#
# Install and configure OpenVPN Access Server
#
# @example
#   include ::openvpnas
#
class openvpnas (
  Variant[Enum['present', 'absent', 'purged', 'disabled', 'installed', 'latest'], String[1]] $package_ensure = 'installed',
  Enum['running', 'stopped'] $service_ensure = 'running',
  Boolean $service_enable                    = true,
  String $service_name                       = 'openvpnas',
) {
  contain 'openvpnas::install'
  contain 'openvpnas::service'

  Class['openvpnas::install']
  -> Class['openvpnas::service']
}
