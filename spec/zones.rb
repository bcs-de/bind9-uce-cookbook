
#
# Data for zones to use in the spec-tests
#
module ZoneData
  MASTERZONES = [
    {
      domain: 'zone1.example.com',
      type: 'master',
      allow_transfer: [],
      zone_info: {
        global_ttl: 300,
        soa: 'ns1.zone1.example.com.',
        contact: 'admin.zone1.example.com.',
        records: [
          { ip: '1.0.0.1', type: 'A', name: 'ns1' },
          { ip: '1.0.0.2', type: 'A', name: 'ns2' },
          { ip: '1.0.1.1', type: 'A', name: 'mx1' },
          { ip: '1.0.1.2', type: 'A', name: 'mx2' },
          { ip: '1.0.3.1', type: 'A', name: 'www1' },
          { ip: 'www1', type: 'CNAME', name: 'www' }
        ],
        mail_exchange: [
          { priority: 10, host: 'mx1' },
          { priority: 10, host: 'mx2' }
        ],
        nameserver: ['ns2.zone1.example.com.']
      }
    },
    {
      domain: 'zone2.example.com',
      type: 'master',
      allow_transfer: [],
      zone_info: {
        global_ttl: 300,
        soa: 'ns1.zone2.example.com.',
        contact: 'admin.zone2.example.com.',
        records: [
          { ip: '2.0.0.1', type: 'A', name: 'ns1' },
          { ip: '2.0.0.2', type: 'A', name: 'ns2' },
          { ip: '2.0.1.1', type: 'A', name: 'mx1' },
          { ip: '2.0.1.2', type: 'A', name: 'mx2' },
          { ip: '2.0.3.1', type: 'A', name: 'www1' },
          { ip: 'www1', type: 'CNAME', name: 'www' }
        ],
        mail_exchange: [
          { priority: 10, host: 'mx1' },
          { priority: 10, host: 'mx2' }
        ],
        nameserver: ['ns2.zone2.example.com.']
      }
    }
  ]
  SLAVEZONES = [
    {
      domain: 'zone1.example.com',
      type: 'slave',
      masters: ['1.0.0.1', '1.0.0.2']
    },
    {
      domain: 'zone2.example.com',
      type: 'slave',
      masters: ['2.0.0.1', '2.0.0.2']
    }
  ]
  FORWARDZONES = [
    {
      domain: 'zone1.example.com',
      type: 'forward',
      masters: ['1.0.0.1', '1.0.0.2']
    },
    {
      domain: 'zone2.example.com',
      type: 'forward',
      masters: ['2.0.0.1', '2.0.0.2']
    }
  ]
end
