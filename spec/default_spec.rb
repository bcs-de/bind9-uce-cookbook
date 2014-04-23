
require 'chefspec'
require 'chefspec/berkshelf'

describe 'bind9-uce::default' do

  before do
    stub_search('reversezones', '*:*').and_return([])
    stub_search('zones', 'type:master').and_return([])
    stub_search('zones', 'type:slave').and_return([])
    stub_search('zones', 'type:forward').and_return([])
  end

  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs bind9' do
    expect(chef_run).to install_package('bind9')
    expect(chef_run).to enable_service('bind9')
  end

  it 'creates config files with content' do
    # expect(chef_run).to create_directory('/etc/bind')
    expect(chef_run).to render_file('/etc/bind/named.conf') \
      .with_content('view internet in')
    expect(chef_run).to render_file('/etc/bind/named.conf.options') \
      .with_content(/allow-recursion {\n[ ]+none;/)
    expect(chef_run).to render_file('/etc/bind/named.conf.options') \
      .with_content(/allow-transfer {\n[ ]+none;/)
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('//include "/etc/bind/zones.rfc1918";')
  end

  it 'creates the basic directories for cache and logging' do
    expect(chef_run).to create_directory('/var/log/bind')
    expect(chef_run).to create_directory('/var/cache/bind')
  end
end

describe 'bind9-uce::default with chroot' do

  before do
    pending 'Chroot testing is not working'
    stub_search('reversezones', '*:*').and_return([])
    stub_search('zones', '*:*').and_return([])
  end

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:bind9][:chroot_dir] = '/var/tmp'
    end.converge('bind9-uce::default')
  end

  it 'installs bind9' do
    expect(chef_run).to install_package('bind9')
    expect(chef_run).to enable_service('bind9')
  end

  it 'creates config files with content' do
    # expect(chef_run).to create_directory('/etc/bind')
    expect(chef_run).to render_file('/var/tmp/etc/bind/named.conf') \
      .with_content('view internet in')
    expect(chef_run).to render_file('/var/tmp/etc/bind/named.conf.options') \
      .with_content(/allow-recursion {\n[ ]+none;/)
    expect(chef_run).to render_file('/var/tmp/etc/bind/named.conf.options') \
      .with_content(/allow-transfer {\n[ ]+none;/)
    expect(chef_run).to render_file('/var/tmp/etc/bind/named.conf.local') \
      .with_content('//include "/etc/bind/zones.rfc1918";')

  end
end
