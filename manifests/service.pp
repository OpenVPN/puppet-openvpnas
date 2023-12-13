# @summary Manage OpenVPN Access Server service
#
# Manage OpenVPN Access Server service and it's state
#
class openvpnas::service {
  service { $openvpnas::service_name:
    ensure     => $openvpnas::service_ensure,
    enable     => $openvpnas::service_enable,
    hasstatus  => true,
    hasrestart => true,
  }
}
