#
# Cookbook Name:: rails_mongodb_app
# Recipe:: _base
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apt"
package 'vim'
# Needed by both mongodb and web app install
include_recipe "build-essential"

