#
# Cookbook Name:: rails_mongodb_app
# Recipe:: load_balancer
#
# Copyright (C) 2014 Braden Wright
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "rails_mongodb_app"

# Installs ssl snake-oil certs
package "ssl-cert"

bash "setup snakeoil.pem" do
  cwd '/etc/ssl'
  code <<-EOH
  cat private/ssl-cert-snakeoil.key certs/ssl-cert-snakeoil.pem > snakeoil.pem
  EOH
  not_if { ::File.exists? '/etc/ssl/snakeoil.pem'  }
end

include_recipe "haproxy::default"

#begin
r = resources(:template => "#{node['haproxy']['conf_dir']}/haproxy.cfg")
r.cookbook "rails_mongodb_app"
#rescue Chef::Exceptions::ResourceNotFound
#  Chef::Log.warn "could not find haproxy.cfg.erb template to override!"
#end

