require 'securerandom'

default['ruby']['rails_env'] = "development"

default['mysql']['server_root_password'] = SecureRandom.hex(10)
default['mysql']['username'] = "root"
default['mysql']['password'] = node['mysql']['server_root_password']
default['mysql']['host'] = "localhost"

