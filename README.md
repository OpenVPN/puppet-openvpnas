# puppet-openvpnas

This is a Puppet module for managing the [OpenVPN Access
Server](https://openvpn.net/vpn-server/). Currently it only contains Puppet
types and providers, but that will change in the future.

# Usage

## Installing OpenVPN Access Server

To install OpenVPN Access Server from the official apt/yum repositories is as
simple as:

    include ::openvpnas

## openvpnas_config

To define server configuration parameters use the openvpnas_config type:

    openvpnas_config { 'vpn.tls_refresh.interval':
      value => '100',
    }

You can get a list of configuration keys and their current values with

    $ /usr/local/openvpn_as/scripts/sacli ConfigQuery

To convert current Access Server configuration into Puppet code use

    $ puppet resource openvpnas_config

## openvpnas_userprop

To define Access Server user properties use the openvpnas_userprop type:

    openvpnas_userprop { 'openvpn-prop_superuser':
      value => 'true',
    }

The resource parameter "name" (defaults to resource title) must consist of three
parts:

1. User or group name (e.g. "__DEFAULT__" or "openvpn")
1. A dash
1. Name of the user property to managed (e.g. "prop_superuser")

If the syntax of the title is wrong catalog compilation will fail.

You can get a list of current user properties with

    $ /usr/local/openvpn_as/scripts/sacli UserPropGet

To convert current user properties into Puppet code use

    $ puppet resource openvpnas_userprop

# Warnings

Please note that "sacli" does not do any validation on the data it gets: make
sure the values you give it make sense or you risk breaking your VPN server
configuration. The types also do not automatically trigger a service restart
if configuration is changed.

Also note that all properties need to be passed to the types as strings - even
those that look like booleans.

The openvpnas_config and openvpnas_userprop types are ensurable, meaning that
you can add arbitrary keys and values to the database, or remove any key that
is present there. Use extreme caution when removing keys.
