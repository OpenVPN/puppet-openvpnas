# frozen_string_literal: true

module Puppet
  Type.newtype(:openvpnas_config) do
    @doc = 'Manage OpenVPN Access Server configuration parameters'

    ensurable do
      desc 'Add or remove config entry'

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.destroy
      end

      defaultto :present
    end

    newparam(:conf_key, namevar: true) do
      desc 'Key in config database'
      validate do |conf_key|
        raise('Property key must be a string') unless conf_key.is_a?(String)
      end
    end

    newproperty(:conf_value) do
      desc 'Value for the key'
      validate do |conf_value|
        raise('Property value must be a string') unless conf_value.is_a?(String)
      end
    end
  end
end
