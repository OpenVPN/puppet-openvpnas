define openvpnas::userprop (
  String $ensure = present,
  String $value,
) {
  openvpnas_userprop { $name:
    ensure => $ensure,
    value => $value,
  }
}
