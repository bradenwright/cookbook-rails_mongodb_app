#
# Cookbook Name:: rails_mongodb_app
# Recipe:: web_app
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'rails_mongodb_app'

project_name = node[:rails_mongodb_app][:project_name]
username = node[:rails_mongodb_app][:user]
group = node[:rails_mongodb_app][:group]
user_home = node[:rails_mongodb_app][:home_dir]

app_shared_dir = "#{user_home}/deploy/shared"
app_current_dir = "#{user_home}/deploy/current"
ruby_version = node[:rails_mongodb_app][:ruby_version]
rails_version = node[:rails_mongodb_app][:rails_version]
rails_env = node[:rails_mongodb_app][:rails_env]

include_recipe "git"
include_recipe "rbenv"
include_recipe "rbenv::ruby_build"
include_recipe "rbenv::rbenv_vars"

rbenv_ruby ruby_version do
  global true
end

rbenv_gem "bundler" do
  ruby_version ruby_version
end

rbenv_gem "rails" do
  ruby_version ruby_version
  version rails_version
end

%w{ deploy deploy/shared deploy/shared/log deploy/shared/pids deploy/shared/system deploy/shared/config }.each do |folder|
  directory "#{user_home}/#{folder}" do
    owner username
    group group
  end
end

%w(nodejs imagemagick libmagickwand-dev curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev).each do |pkg|
  package pkg do
    action :nothing 
  end.run_action(:install)
end

ENV['RAILS_ENV'] = rails_env

rbenv_gem "eye"

eye_config_file = "#{app_shared_dir}/config/#{project_name}.eye"

template eye_config_file do
  source "unicorn.eye.erb"
  owner username
  group group
  mode 0640
  variables(
    :ruby => "/opt/rbenv/shims/ruby",
    :app_current_dir => app_current_dir,
    :app_shared_dir => app_shared_dir,
    :rails_env => rails_env,
    :service_name => project_name,
    :process_name => node[:rails_mongodb_app][:unicorn][:process_name]
  )
end

template "/etc/init.d/#{project_name}" do
  source "eye_unicorn.init.d.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(
    :service_name => project_name,
    :process_name => node[:rails_mongodb_app][:unicorn][:process_name],
    :config_file => eye_config_file,
    :user => username
  )
  only_if { ::File.exists?(eye_config_file) }
end

template "#{app_shared_dir}/config/unicorn.rb" do
  source "unicorn.rb.erb"
  owner username
  group group
  mode 0640
  variables(
    :num_of_workers => 9,
    :timeout => 90,
    :app_current_dir => app_current_dir,
    :app_shared_dir => app_shared_dir
  )
end

template "#{app_shared_dir}/config/mongoid.yml" do
  source "mongoid.yml.erb"
  owner username
  group group
  mode 0640
  variables(
    :project_name => project_name,
    :hosts => node[:rails_mongodb_app][:mongos_servers],
    :mongo_port => 27017,
    :rails_env => rails_env,
    :read_option => "secondary_preferred",
    :max_retries => 15,
    :retry_interval => 15
  )
end

if File.exists? "/mnt/rails_mongodb_app"
  bash "Change ownership of /mnt/rails_mongodb_app" do
    user "root"
    code <<-EOH
      cp -r /root/.ssh #{user_home}
      chown -R #{username}:#{group} #{user_home}/.ssh
      chown -R #{username}:#{group} /mnt/rails_mongodb_app
    EOH
  end

  link "#{user_home}/deploy/current" do
    owner username
    group group
    to "/mnt/rails_mongodb_app"
  end

  link "#{app_current_dir}/config/mongoid.yml" do
    owner username
    group group
    to "#{app_shared_dir}/config/mongoid.yml"
  end

##{'bundle exec rake assets:precompile' unless node[project_name][:rails_env] == "development"}
  bash "bundler update" do
    user username
    ENV['HOME'] = user_home
    flags "-l"
    cwd "#{user_home}/deploy/current"
    code <<-EOH
      bundle install
      export RAILS_ENV=#{rails_env}
      #{'bundle exec rake assets:precompile' if rails_env == "production" }
    EOH
  end
else
  deploy_revision "#{user_home}/deploy" do
    user username
    group group
    repository node[:rails_mongodb_app][:git_repo]
    branch node[:rails_mongodb_app][:git_branch]
    migrate false
    user username
    environment "RAILS_ENV" => rails_env
    keep_releases 10
    action node[:rails_mongodb_app][:deploy]
    #git_ssh_wrapper ""
    #rollback_on_error true
    symlink_before_migrate "config/mongoid.yml" => "config/mongoid.yml"

    before_symlink do
      bash "bundler update" do
        user username
        ENV['HOME'] = user_home
        flags "-l"
        cwd "#{user_home}/deploy/releases"
        code <<-EOH
          cd `ls -t | awk 'NR<2'`
          bundle install
          export RAILS_ENV=#{rails_env}
          #{'bundle exec rake assets:precompile' unless rails_env == "development"}
        EOH
      end
    end
    restart_command "test -e /etc/init.d/#{project_name} && service #{project_name} restart || exit 0"
  end
end

include_recipe 'runit'
include_recipe 'nginx::source'

template "/etc/nginx/sites-available/#{project_name}" do
  source "nginx-site.erb"
  owner "root"
  group "root"
  mode 0555
  variables(
    :home_dir => user_home,
    :rails_env => rails_env )
  notifies :restart, "service[nginx]"
end

nginx_site project_name

service project_name do
  action [:enable, :start]
  supports :status => true, :start => true, :stop => true, :restart => true
  subscribes :restart, "template[#{eye_config_file}]"
end

