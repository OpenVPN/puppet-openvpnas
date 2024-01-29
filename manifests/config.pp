define openvpnas::config (
  String $ensure = present,
  String $value,
) {
  openvpnas_config { $name:
    ensure => $ensure,
    value => $value,
  }
}
