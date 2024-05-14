# frozen_string_literal: true

#
module Puppet
  Type.newtype(:openvpnas_user) do
    @doc = 'Manage OpenVPN Access Server users'

    ensurable do
      desc 'Add or remove user'

      newvalue(:present) do
        provider.create
      end

      newvalue(:absent) do
        provider.destroy
      end

      defaultto :present
    end

    newparam(:name, namevar: true) do
      desc 'The username.'
      validate do |name|
        raise('Name must be a string') unless name.is_a?(String)
        raise("Resource name \'#{name}\' is invalid. #{format_str}") unless name =~ %r{^(\w|_|\.|@|-)+$}
      end
    end
  end
end
