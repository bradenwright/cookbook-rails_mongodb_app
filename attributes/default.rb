#
# Cookbook Name:: rails_mongodb_app
# Attribute:: default
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

default[:rails_mongodb_app][:project_name] = "myapp"
default[:rails_mongodb_app][:user] = "myapp"
default[:rails_mongodb_app][:group] = "myapp"
default[:rails_mongodb_app][:home_dir] = "/home/myapp"
default[:rails_mongodb_app][:ruby_version] = "2.2.1"
default[:rails_mongodb_app][:rails_version] = "4.0.4"
default[:rails_mongodb_app][:rails_env] = "production"
default[:rails_mongodb_app][:unicorn][:process_name] = "unicorn"
default[:rails_mongodb_app][:deploy] = "deploy" # deploy, force_deploy, rollback
#default[:rails_mongodb_app][:git_repo] = "ssh://"
#default[:rails_mongodb_app][:git_branch] = "master"

force_default[:apt][:compiletime] = true
force_default[:apt][:compile_time_update] = true
force_default['build-essential'][:compile_time] = true

# NTP
force_default[:ntp][:sync_clock] = true
#force_default[:ntp][:sync_hw_clock] = true
#force_default[:ntp][:apparmor_enabled] = false

force_default['hostsfile']['path'] = "/etc/hosts"

default[:rbenv][:user]   = "myapp"
default[:rbenv][:group]  = "myapp"
default[:rbenv][:user_home] = "/home/myapp"

# Eye
force_default[:eye][:bin] = "/opt/rbenv/shims/eye"

# NGINX
force_default[:nginx][:default_site_enabled] = false
force_default[:nginx][:source][:modules] = ["nginx::http_gzip_static_module","nginx::http_ssl_module"]
#force_default[:nginx][:source][:version] = "1.7.10"
#force_default['nginx']['source']['url'] = "http://nginx.org/download/nginx-1.7.10.tar.gz"
#force_default[:nginx][:version] = "1.7.10"
#force_default[:nginx][:source][:checksum] = "df73c1b468cebaf3530a5de910bed45ff2cfccf2cf4b9215d0aa0f4e39cf4460"
default[:nginx][:source][:checksum] = "b5608c2959d3e7ad09b20fc8f9e5bd4bc87b3bc8ba5936a513c04ed8f1391a18"

# HAPROXY
force_default['haproxy']['install_method'] = "source"
force_default['haproxy']['source']['version'] = "1.5.11"
force_default['haproxy']['source']['url'] = 'http://www.haproxy.org/download/1.5/src/haproxy-1.5.11.tar.gz'
force_default['haproxy']['source']['checksum'] = '8b5aa462988405f09c8a6169294b202d7f524a5450a02dd92e7c216680f793bf'
force_default['haproxy']['source']['use_openssl'] = true

# MONGODB
default[:mongodb][:cluster_name] = "myapp"
#force_default[:mongodb][:config][:rest] = true
default[:mongodb][:config][:bind_ip] = '0.0.0.0'
default[:mongodb][:replica_priority] = 20
# mongodb 3.0
# next 3 options need for lxc without upstart
force_default[:mongodb][:apt_repo] = 'debian-sysvinit'
force_default[:mongodb][:init_dir] = '/etc/init.d'
force_default[:mongodb][:init_script_template] = 'debian-mongodb.init.erb'
default[:mongodb][:default_init_name] = 'mongod'
default[:mongodb][:instance_name] = 'mongod'
default[:mongodb][:dbconfig_file] = '/etc/mongod.conf'
default[:mongodb][:sysconfig]['DAEMON_OPTS'] = "--config #{node[:mongodb][:dbconfig_file]}"
default[:mongodb][:sysconfig]['CONFIGFILE'] = node[:mongodb][:dbconfig_file]
# for monitoring on port 28017
default[:mongodb][:config][:storageEngine] = "wiredTiger"
force_default['mongodb']['ruby_gems'] = {
  :mongo => "1.12.0",
  :bson_ext => nil
}

