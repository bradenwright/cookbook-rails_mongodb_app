#
# Cookbook Name:: rails_mongodb_app
# Recipe:: _shard
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

node.force_default[:mongodb][:replica_priority] = 20
node.force_default[:mongodb][:config][:rest] = true

include_recipe "rails_mongodb_app::_database"
include_recipe "mongodb::shard"
include_recipe "mongodb::replicaset"
