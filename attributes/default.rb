default['ruby']['rails_env'] = "development"

default['mysql']['username'] = "root"
default['mysql']['password'] = node['mysql']['initial_root_password']
default['mysql']['host'] = "localhost"
default['mysql']['version'] = "5.6"
