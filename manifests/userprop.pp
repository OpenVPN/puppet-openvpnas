define openvpnas::userprop (
  String $value,
  String $ensure = present,
) {
  openvpnas_userprop { $name:
    ensure => $ensure,
    value  => $value,
  }
}
