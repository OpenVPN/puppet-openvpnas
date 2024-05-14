define openvpnas::user (
  String $ensure = present,
) {
  openvpnas_user { $name:
    ensure => $ensure
  }
}
