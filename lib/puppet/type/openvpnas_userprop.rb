# frozen_string_literal: true

#
module Puppet
  Type.newtype(:openvpnas_userprop) do
    @doc = 'Manage OpenVPN Access Server user properties'

    ensurable do
      desc 'Add or remove user property'

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.destroy
      end

      defaultto :present
    end

    newparam(:name, namevar: true) do
      desc 'Path to the user property in "user-key" format.'
      format_str = 'Should be in format user-key or group-key!'
      validate do |name|
        raise('Name must be a string') unless name.is_a?(String)
        raise("Resource name \'#{name}\' is invalid. #{format_str}") unless name =~ %r{^(\w|_)+-(\w|_)+$}
      end
    end

    newproperty(:value) do
      desc 'Value for the user property key'
      validate do |value|
        raise('User property value must be a string') unless value.is_a?(String)
      end
    end
  end
end
