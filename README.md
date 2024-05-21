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

In the user/group name part only word characters, "." and "\_" are allowed. If
your usernames contain other characters please let us know or, better yet,
modify the "name" parameter's validation regexp in
[lib/puppet/type/openvpnas_userprop.rb](lib/puppet/type/openvpnas_userprop.rb)
and issue a pull request.

You can get a list of current user properties with

    $ /usr/local/openvpn_as/scripts/sacli UserPropGet

To convert current user properties into Puppet code use

    $ puppet resource openvpnas_userprop

## openvpnas_user

This resource allows to perform user management in Access Server:

    openvpnas_user { 'test':
      ensure => present
    }

Allowed state of user: "present" and "absent"

To convert current Access Server user configuration into Puppet code use

    $ puppet resource openvpnas_user

You may exclude "provider => 'sacli'," when using "openvpnas_user" resource in Puppet manifest.
To manage userprops for users created via resource "openvpnas_user" use resource "openvpnas_userprop"

## Defining settings in Hiera for automatic lookup of class parameters

It is also possible to define all settings in Hiera and just `include openvpnas`
module in your manifest, which will then automatically lookup the class
parameters from Hiera data. Here is an example of Hiera data:

    openvpnas::package_ensure: installed
    openvpnas::service_ensure: running
    openvpnas::service_enable: true
    openvpnas::service_name: openvpnas
    openvpnas::config:
      vpn.tls_refresh.interval:
        ensure: present
        value: '100'
    openvpnas::userprop:
      openvpn-prop_superuser:
        ensure: present
        value: 'true'

To convert current Access Server configuration and user properties into Hiera values use the following commands and adjust the top level keys

    $ puppet resource openvpnas_config --to_yaml
    $ puppet resource openvpnas_userprop --to_yaml

Note: It was observed that the value of the openvpnas_config resource `subscription.saved_state` changes often and might not be a good idea to set that to a fixed value with Puppet. It is recommended to use eYAML to encrypt the several secrets that are dumped in plain text.

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
