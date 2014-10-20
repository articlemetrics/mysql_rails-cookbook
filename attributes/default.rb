require 'securerandom'

default['mysql']['server_root_password'] = SecureRandom.hex(10)
