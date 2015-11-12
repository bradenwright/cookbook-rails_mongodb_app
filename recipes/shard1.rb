#
# Cookbook Name:: rails_mongodb_app
# Recipe:: shard1
#
# Copyright (C) 2014 Braden Wright
# 
# All rights reserved - Do Not Redistribute
#

node.force_default[:mongodb][:shard_name] = "shard1"
node.force_default['mongodb']['config']['replSet'] = "rs_shard1"
include_recipe "rails_mongodb_app::_shard"

