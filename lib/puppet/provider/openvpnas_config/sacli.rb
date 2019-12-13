# frozen_string_literal: true

require 'json'

Puppet::Type.type(:openvpnas_config).provide(:sacli) do
  defaultfor kernel: 'Linux'

  commands sacli: '/usr/local/openvpn_as/scripts/sacli'

  def create
    sacli('--key',   resource[:name],
          '--value', resource[:value],
          'ConfigPut')
  end

  def destroy
    sacli('--key', @property_hash[:name], 'ConfigDel')
  end

  def self.instances
    res = []
    sacli_output = sacli('ConfigQuery')
    config = JSON.parse(sacli_output)

    config.each_pair do |key, value|
      res << new(name: key,
                 ensure: :present,
                 key: key,
                 value: value)
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
    sacli('--key', @property_hash[:key], '--value', value, 'ConfigPut')
  end
end
