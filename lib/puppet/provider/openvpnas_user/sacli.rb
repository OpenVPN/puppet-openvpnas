# frozen_string_literal: true

require 'json'

Puppet::Type.type(:openvpnas_user).provide(:sacli) do
  defaultfor kernel: 'Linux'

  commands sacli: '/usr/local/openvpn_as/scripts/sacli'

  def user
    resource[:name]
  end

  def create
    sacli('--user',  user,
          '--key',   'type',
          '--value', 'user_connect',
          'UserPropPut')
  end

  def destroy
    sacli('--user', user,
          'UserPropDelAll')
  end

  def self.instances
    res = []
    sacli_output = sacli('UserPropGet')
    config = JSON.parse(sacli_output)

    Puppet.debug(config)
    config.each do |entry|
      Puppet.debug("Found userprop entry: #{entry}")
        res << new(name: "#{entry[0]}", ensure: :present) unless entry[0] == '__DEFAULT__'
    end
    res
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if (resource = resources[prov.name])
        resource.provider = prov
        Puppet.debug(prov)
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end

end
