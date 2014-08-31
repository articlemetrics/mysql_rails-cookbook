actions :config, :setup, :migrate, :drop, :cleanup
default_action :config

attribute :name, :kind_of => String, :name_attribute => true
attribute :rails_env, :kind_of => String, :default => "production"
attribute :deploy_user, :kind_of => String, :default => node[:user]
attribute :group, :kind_of => String, :default => "www-data"
attribute :username, :kind_of => String, :default => "root"
attribute :password, :kind_of => String, :default => ""
attribute :host, :kind_of => String, :default => "localhost"
