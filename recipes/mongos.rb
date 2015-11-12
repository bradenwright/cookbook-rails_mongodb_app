#
# Cookbook Name:: rails_mongodb_app
# Recipe:: mongos
#
# Copyright (C) 2015 Braden Wright
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rails_mongodb_app::_database"

=begin
node.set[:mongodb][:sharded_collections] = {
  "myapp_production.users" => "name",
  "myapp_production.artists" => "name",
  "myapp_production.albums" => "name",
  "myapp_production.tracks" => "album_id",
  "myapp_production.players" => "_id",
  "myapp_production.playlists" => "name",
  "myapp_production.playlist_tracks" => "playlist_id",
  "myapp_production.fs.files" => "_id",
  "myapp_production.fs.chunks" => "files_id"
}
=end

%w(nojournal rest smallfiles storageEngine).each do |k|
  node.default['mongodb']['config'].delete(k) rescue nil
  node.force_default['mongodb']['config'].delete(k) rescue nil
end

include_recipe "mongodb::mongos"
