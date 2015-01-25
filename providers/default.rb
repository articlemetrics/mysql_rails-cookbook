def whyrun_supported?
  true
end

use_inline_resources

def load_current_resource
  @current_resource = Chef::Resource::MysqlRails.new(new_resource.name)
end

action :create do
  # set mysql root password
  node.set['mysql']['initial_root_password'] = new_resource.root_password

  # install mysql
  run_context.include_recipe 'ruby::empty'

  mysql_service 'default' do
    action [:create, :start]
  end

  mysql_config 'default' do
    source "my.cnf.erb"
    notifies :restart, 'mysql_service[default]'
    action :create
  end

  run_context.include_recipe 'database::mysql'

  # create database
  mysql_database new_resource.name do
    connection mysql_connection_info
    action :create
  end

  # create database user with all privileges
  mysql_database_user new_resource.username do
    connection mysql_connection_info
    password   new_resource.password
    host       new_resource.host
    privileges [:all]
    action     [:create, :grant]
  end
end

action :drop do
  mysql_database "#{new_resource.name}_#{new_resource.rails_env}" do
    connection mysql_connection_info
    action :drop
  end
end

def mysql_connection_info
  { host:      new_resource.host,
    username:  'root',
    password:  new_resource.root_password }
end
