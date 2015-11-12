#
# Cookbook Name:: rails_mongodb_app
# Recipe:: config_server
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rails_mongodb_app::_database"
include_recipe "mongodb::configserver"

