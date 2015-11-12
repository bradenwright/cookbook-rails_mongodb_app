#
# Cookbook Name:: rails_mongodb_app
# Recipe:: default
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rails_mongodb_app::_base"

mongo_db_nodes = search(:node, 'recipes:rails_mongodb_app\:\:_database')

mongo_db_nodes.each do |vm|
  node.default[:rails_mongodb_app][:mongo_db_servers][vm['fqdn']] = vm['ipaddress']
end

mongos_nodes = search(:node, 'recipes:rails_mongodb_app\:\:mongos AND chef_environment:'+node.chef_environment)

mongos_nodes.each do |vm|
  node.default[:rails_mongodb_app][:mongos_servers][vm['fqdn']] = vm['ipaddress']
end

rails_app_nodes = search(:node, 'recipes:rails_mongodb_app\:\:web_app AND chef_environment:'+node.chef_environment)

rails_app_nodes.each do |vm|
  node.default[:rails_mongodb_app][:rails_app_servers][vm['fqdn']] = vm['ipaddress']
end

haproxy_nodes = search(:node, 'recipes:rails_mongodb_app\:\:load_balancer AND chef_environment:'+node.chef_environment)

haproxy_nodes.each do |vm|
  node.default[:rails_mongodb_app][:haproxy_servers][vm['fqdn']] = vm['ipaddress']
end

rails_mongodb_app_servers = [ ] 
rails_mongodb_app_servers << node[:rails_mongodb_app][:mongo_db_servers] rescue  nil
rails_mongodb_app_servers << node[:rails_mongodb_app][:mongos_servers] rescue nil
rails_mongodb_app_servers << node[:rails_mongodb_app][:haproxy_servers] rescue nil
rails_mongodb_app_servers << node[:rails_mongodb_app][:rails_app_servers] rescue nil

rails_mongodb_app_servers.each do |servers|
  servers.each do |host, ip|
    hostsfile_entry ip do
      hostname host
      unique true
      not_if { ip.nil? || ip == "DO_NOT_USE" || ip == node[:ip_address] || host == node[:fqdn] }
    end
  end unless servers.nil?
end unless rails_mongodb_app_servers.nil?

