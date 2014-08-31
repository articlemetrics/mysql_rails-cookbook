actions :config, :setup, :migrate, :drop, :cleanup
default_action :config

attribute :name, :kind_of => String, :name_attribute => true
attribute :rails_env, :kind_of => String, :default => "production"
attribute :deploy_user, :kind_of => String, :default => "www-data"
attribute :group, :kind_of => String, :default => "www-data"
attribute :db_user, :kind_of => String, :default => "root"
attribute :db_password, :kind_of => String, :default => ""
attribute :host, :kind_of => String, :default => "localhost"
