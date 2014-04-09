
require_relative 'spec_helper'
require_relative 'zones'

describe 'slave zones' do

  before do
    stub_search('reversezones', '*:*').and_return([])
    stub_search('zones', 'type:master').and_return([])
    stub_search('zones', 'type:slave') { ZoneData::SLAVEZONES }
    stub_search('zones', 'type:forward').and_return([])
  end

  let(:chef_run) { ChefSpec::Runner.new.converge('bind9-uce::default') }

  it 'has slave zones zone1.example.com and zone2.example.com' do
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('zone1.example.com')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('zone2.example.com')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('1.0.0.1')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('1.0.0.2')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('2.0.0.1')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('2.0.0.2')
  end
  it 'has only slaves defined' do
    expect(chef_run).not_to render_file('/etc/bind/named.conf.local') \
      .with_content('master;')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('slave;')
    expect(chef_run).not_to render_file('/etc/bind/named.conf.local') \
      .with_content('forward;')
  end
end
