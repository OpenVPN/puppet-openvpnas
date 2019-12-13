require 'spec_helper'

describe Puppet::Type.type(:openvpnas_userprop) do
  let(:default_config) do
    {
      name: 'foo-bar',
      value: 'foobar',
    }
  end

  let(:config) do
    default_config
  end

  let(:resource) do
    described_class.new(config)
  end

  it 'can be added to catalog with sane values' do
    catalog = Puppet::Resource::Catalog.new
    expect {
      catalog.add_resource resource
    }.not_to raise_error
  end

  bad_names = ['-', '--', 'foo', '-foo', 'foo-', 'foo-bar-foo']
  bad_names.each do |name|
    context "should fail with bad name #{name}" do
      let(:config) do
        super().merge(name: name)
      end

      let(:resource) do
        described_class.new(config)
      end

      it 'cannot be added to catalog with bad name' do
        catalog = Puppet::Resource::Catalog.new
        expect {
          catalog.add_resource resource
        }.to raise_error(Puppet::ResourceError)
      end
    end
  end
end
