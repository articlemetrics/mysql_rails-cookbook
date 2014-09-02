actions :config, :setup, :migrate, :drop, :cleanup
default_action :config

attribute :name, :kind_of => String, :name_attribute => true
attribute :rails_env, :kind_of => String, :default => node['ruby']['rails_env']
attribute :user, :kind_of => String, :default => node['ruby']['user']
attribute :group, :kind_of => String, :default => node['ruby']['group']
attribute :username, :kind_of => String, :default => node['ruby']['db']['username']
attribute :password, :kind_of => String, :default => node['ruby']['db']['password']
attribute :host, :kind_of => String, :default => node['ruby']['db']['host']
