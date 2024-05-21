define openvpnas::config (
  String $value,
  String $ensure = present,
) {
  openvpnas_config { $name:
    ensure => $ensure,
    value  => $value,
  }
}
