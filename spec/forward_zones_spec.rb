
require_relative 'spec_helper'
require_relative 'zones'

describe 'forward zones' do

  before do
    stub_search('reversezones', '*:*').and_return([])
    stub_search('zones', 'type:master').and_return([])
    stub_search('zones', 'type:slave') { [] }
    stub_search('zones', 'type:forward') { ZoneData::FORWARDZONES }
  end

  let(:chef_run) { ChefSpec::Runner.new.converge('bind9-uce::default') }

  it 'has forward zones zone1.example.com and zone2.example.com' do
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
  it 'has only forwards defined' do
    expect(chef_run).not_to render_file('/etc/bind/named.conf.local') \
      .with_content('master;')
    expect(chef_run).not_to render_file('/etc/bind/named.conf.local') \
      .with_content('slave;')
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('forward;')
  end
end
