require 'spec_helper'

describe Puppet::Type.type(:openvpnas_config) do
  let(:default_config) do
    {
      name: 'key',
      value: 'value',
    }
  end

  let(:config) do
    default_config
  end

  let(:resource) do
    described_class.new(config)
  end

  it 'can be added to catalog' do
    catalog = Puppet::Resource::Catalog.new
    expect {
      catalog.add_resource resource
    }.not_to raise_error
  end
end
