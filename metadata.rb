name             'mysql_rails'
maintainer       'Martin Fenner'
maintainer_email 'mfenner@plos.org'
license          'Apache 2.0'
description      'Installs and configures MySQL for Rails applications'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "0.3.27"
depends           "mysql", "~> 5.6.1"
depends           "database", "~> 2.3.1"
depends           "ruby", "~> 0.6.0"
