# puppet-openvpnas

This is a Puppet module for managing the [OpenVPN Access
Server](https://openvpn.net/vpn-server/). Currently it only contains Puppet
types and providers, but that will change in the future.

# Usage

To define server configuration parameters use the openvpnas_config type:

    openvpnas_config { 'vpn.tls_refresh.interval':
      value  => '100',
    }

The provider uses "sacli" under the hood, so please use

    $ sacli ConfigQuery

to get a list of configuration keys and current values. Please note that
"sacli" does not do any validation on the data it gets: make sure the values
you give it make sense or you risk breaking your VPN server configuration. The
type also does not automatically trigger a service restart if configuration
is changed.

The openvpnas_config type is ensurable, meaning that you can add arbitrary keys
and values to the database, or remove any key that is present here. Use extreme
caution when removing keys.
