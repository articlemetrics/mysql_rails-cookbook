require 'securerandom'

default['mysql']['server_root_password'] = SecureRandom.hex(10)

default['ruby']['rails_env'] = "development"
default['mysql']['username'] = "root"
default['mysql']['password'] = nil
default['mysql']['host'] = "localhost"
