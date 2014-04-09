name             'bind9-uce'
maintainer       'Tnarik Innael'
maintainer       'Arnold Krille'
maintainer_email 'tnarik@lecafeautomatique.co.uk'
maintainer_email 'a.krille@b-c-s.de'
license          'Apache 2.0'
description      'Installs/Configures bind9 with chroot and hiding CHAOS INFORMATION, support master-, slave- and forward-zones.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{ ubuntu debian centos }.each do |os|
  supports os
end

%w{resolvconf}.each do |cookbook|
  depends(cookbook)
end
