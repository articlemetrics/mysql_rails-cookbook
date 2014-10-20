actions :create, :drop
default_action :create

attribute :name, :kind_of => String, :name_attribute => true
attribute :rails_env, :kind_of => String, :default => ENV['RAILS_ENV']
attribute :username, :kind_of => String, :default => ENV['DB_USERNAME']
attribute :password, :kind_of => String, :default => ENV['DB_PASSWORD']
attribute :host, :kind_of => String, :default => ENV['DB_HOST']
