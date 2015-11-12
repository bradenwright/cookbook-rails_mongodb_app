#
# Cookbook Name:: rails_mongodb_app
# Recipe:: database
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rails_mongodb_app"
#include_recipe "mongodb::mongodb_org_repo"

node.force_default[:mongodb][:package_name] = 'mongodb-org'

apt_repository 'mongodb' do
  uri "http://repo.mongodb.org/apt/ubuntu"
  distribution "trusty/mongodb-org/3.0"
  components ['multiverse']
  keyserver 'hkp://keyserver.ubuntu.com:80'
  key '7F0CEB10'
  action :add
end

