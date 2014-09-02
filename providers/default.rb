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
      owner new_resource.user
      group new_resource.group
      mode '0755'
      recursive true
    end
  end

  # create database settings file
  %w{ current shared }.each do |dir|
    template "/var/www/#{new_resource.name}/#{dir}/config/database.yml" do
      source 'database.yml.erb'
      owner new_resource.deploy_user
      group new_resource.group
      mode '0644'
      cookbook 'mysql_rails'
      variables(
        :application => new_resource.name,
        :username    => new_resource.username,
        :password    => new_resource.password,
        :host        => new_resource.host
      )
      action :create
    end
  end
end

action :setup do
  run_context.include_recipe 'ruby::empty'
  run_context.include_recipe 'mysql::server'
  run_context.include_recipe 'database::mysql'

  mysql_database "#{new_resource.name}_#{new_resource.rails_env}" do
    connection mysql_connection_info
    action :create
  end

  # create database user with all privileges for the table we just created
  mysql_database_user new_resource.username do
    connection mysql_connection_info
    password   new_resource.password
    action     :create
  end

  mysql_database_user new_resource.username do
    connection    mysql_connection_info
    database_name "#{new_resource.name}_#{new_resource.rails_env}"
    host          new_resource.host
    privileges    [:all]
    action        :grant
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
    username:  'root',
    password:  node['mysql']['server_root_password'] }
end
