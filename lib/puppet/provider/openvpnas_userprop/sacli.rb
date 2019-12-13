# frozen_string_literal: true

require 'json'

Puppet::Type.type(:openvpnas_userprop).provide(:sacli) do
  defaultfor kernel: 'Linux'

  commands sacli: '/usr/local/openvpn_as/scripts/sacli'

  def user
    resource[:name].split('-').shift
  end

  def key
    resource[:name].split('-').drop(1)
  end

  def create
    sacli('--user',  user,
          '--key',   key,
          '--value', resource[:value],
          'UserPropPut')
  end

  def destroy
    sacli('--user', user,
          '--key',  key,
          'UserPropDel')
  end

  def self.instances
    res = []
    sacli_output = sacli('UserPropGet')
    config = JSON.parse(sacli_output)

    Puppet.debug(config)
    config.each do |entry|
      Puppet.debug("Found userprop entry: #{entry}")
      entry[1].each_pair do |key, value|
        res << new(name: "#{entry[0]}-#{key}",
                   ensure: :present,
                   value: value)
      end
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

  def value
    @property_hash[:value]
  end

  def value=(value)
    sacli('--user', user, '--key', key, '--value', value, 'UserPropPut')
  end
end
