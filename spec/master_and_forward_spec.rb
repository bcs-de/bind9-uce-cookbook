
require_relative 'spec_helper'
require_relative 'zones'

describe 'master and slave zones' do

  before do
    stub_search('reversezones', '*:*').and_return([])
    stub_search('zones', 'type:master').and_return([] << ZoneData::MASTERZONES[0])
    stub_search('zones', 'type:slave').and_return(ZoneData::SLAVEZONES)
    stub_search('zones', 'type:slave AND NOT domain:zone1.example.com').and_return([] << ZoneData::SLAVEZONES[1])
    stub_search('zones', 'type:forward').and_return([])
  end

  let(:chef_run) { ChefSpec::Runner.new.converge('bind9-uce::default') }

  it 'has to have zone1.example.com as master zone' do
    expect(chef_run).to render_file('/etc/bind/named.conf.local') \
      .with_content('zone1.example.com')
    expect(chef_run).to render_file('/etc/bind/zones/zone1.example.com.erb')
    expect(chef_run).not_to render_file('/etc/bind/zones/zone2.example.com.erb')
    expect(chef_run).not_to render_file('/etc/bind/named.conf.local') \
      .with_content('1.0.0.1')
  end

  it 'has to have zone2.example.com as slave zone' do
    ['zone2.example.com', '2.0.0.1', '2.0.0.2'].each do |s|
      expect(chef_run).to render_file('/etc/bind/named.conf.local') \
        .with_content(s)
    end
  end
end
