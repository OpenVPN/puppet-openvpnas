# frozen_string_literal: true

#
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

    newparam(:key, namevar: true) do
      desc 'Key in config database'
      validate do |key|
        raise('Property key must be a string') unless key.is_a?(String)
      end
    end

    newproperty(:value) do
      desc 'Value for the key'
      validate do |value|
        raise('Property value must be a string') unless value.is_a?(String)
      end
    end
  end
end
