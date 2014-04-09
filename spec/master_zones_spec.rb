
require_relative 'spec_helper'
require_relative 'zones'

describe 'master zones' do

  before do
    stub_search('reversezones', '*:*').and_return([])
    stub_search('zones', 'type:master') { ZoneData::MASTERZONES }
    stub_search('zones', 'type:slave').and_return([])
    stub_search('zones', 'type:forward').and_return([])
  end

  let(:chef_run) { ChefSpec::Runner.new.converge('bind9-uce::default') }

  it 'installs bind9' do
    expect(chef_run).to install_package('bind9')
    expect(chef_run).to enable_service('bind9')
  end

  it 'has master zones zone1.example.com and zone2.example.com in config' do
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('zone1.example.com')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('zone2.example.com')
  end
  it 'has only masters defined' do
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('master;')
    expect(chef_run).not_to render_file('/etc/bind/named.conf.local') \
      .with_content('slave;')
    expect(chef_run).not_to render_file('/etc/bind/named.conf.local') \
      .with_content('forward;')
  end

  it 'creates a zone-file for zone1.example.com with the correct content' do
    expect(chef_run).to create_directory('/etc/bind/zones')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content('SOA')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content('admin.zone1.example.com')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content('IN    MX 10 mx1')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content('IN    MX 10 mx2')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content('IN    NS ns1.zone1.example.com.')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content('IN    NS ns2.zone1.example.com.')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content(/ns1[ ]+IN     A 1.0.0.1/)
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content(/ns2[ ]+IN     A 1.0.0.2/)
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content(/mx1[ ]+IN     A 1.0.1.1/)
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content(/mx2[ ]+IN     A 1.0.1.2/)
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content(/www1[ ]+IN     A 1.0.3.1/)
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb') \
      .with_content(/www[ ]+IN CNAME www1/)

    # expect(chef_run).to render_file('/etc/bind/zones/example.com') \
    #   .with_content(/SOA/)

    # expect(chef_run).to restart_service('bind9')
  end

end
