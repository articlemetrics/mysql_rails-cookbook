def whyrun_supported?
  true
end

use_inline_resources

def load_current_resource
  @current_resource = Chef::Resource::MysqlRails.new(new_resource.name)
end

action :config do
  # create user
  user new_resource.deploy_user do
    system true
    gid new_resource.group
    shell "/bin/bash"
  end

  # create required folders and set permissions
  %W{ #{new_resource.name} #{new_resource.name}/current #{new_resource.name}/current/config #{new_resource.name}/shared #{new_resource.name}/shared/config }.each do |dir|
    directory "/var/www/#{dir}" do
      owner new_resource.deploy_user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  # create database settings file
  template "/var/www/#{new_resource.name}/shared/config/database.yml" do
    source 'database.yml.erb'
    owner new_resource.deploy_user
    group new_resource.group
    mode '0755'
    cookbook 'mysql_rails'
    variables(
      :application => new_resource.name,
      :username    => new_resource.username,
      :password    => new_resource.password,
      :host        => new_resource.host
    )
  end

  # copy it to the current folder
  file "/var/www/#{new_resource.name}/current/config/database.yml" do
    owner new_resource.deploy_user
    group new_resource.group
    mode 0755
    content ::File.open("/var/www/#{new_resource.name}/shared/config/database.yml").read
  end
end

action :setup do
  run_context.include_recipe 'mysql::server'
  run_context.include_recipe 'database::mysql'

  mysql_database "#{new_resource.name}_#{new_resource.rails_env}" do
    connection mysql_connection_info
    action :create
  end
end

action :drop do
  mysql_database "#{new_resource.name}_#{new_resource.rails_env}" do
    connection mysql_connection_info
    action :drop
  end
end

action :cleanup do
  file "/var/www/#{new_resource.name}/shared/config/database.yml" do
    action :delete
    new_resource.updated_by_last_action(true)
  end
end

def mysql_connection_info
  { host:      new_resource.host,
    username:  new_resource.username,
    password:  new_resource.password }
end
