#
# Cookbook Name:: rails_mongodb_app
# Recipe:: shard2
#
# Copyright (C) 2014 Braden Wright
# 
# All rights reserved - Do Not Redistribute
#

node.force_default[:mongodb][:shard_name] = "shard2"
node.force_default['mongodb']['config']['replSet'] = "rs_shard2"
include_recipe "rails_mongodb_app::_shard"

