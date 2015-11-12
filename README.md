# rails_mongodb_app-cookbook

NOT READY FOR CONSUMPTION YET.  SAVE POINT FOR NOW, WILL PUSH MASTER BRANCH WHEN READY.

This cookbook was setup to show both a working example of using Kitchen-LxdCli driver, as well as a working example of setting up MongoDB with Sharding and Replicasets.  Since while the cookbook works well, it took some tweaking and learning, so unless I get really ambitious and rewrite the mongodb cook book I figure this would help some people.  It also is an example of multiple web nodes with HaProxy load balancing.

I personally use the cookbook to make a few small Rails Apps I'm developing, whose main purpose server is to be learning tool.  The reason I decided to use the technologies: Ubuntu, LXD/LXC, Chef, Test-Kitchen, ServerSpec, HaProxy, Nginx, Rails, Unicorn, MongoDB, etc.  Are because they are technologies I enjoy using and wanted to learn more about.

SUGGESTIONS TO IMPROVE ARE ALWAYS WELCOME!!!

This cookbook is an example of a rails app using mongodb.  It can be used to setup a site in which to develop/create a rails app from scratch.  Or it can be used to point to a git repo and run an existing rails app.  Wanted this to be a Highly Available site, so it uses haproxy, nginx/unicorn, mongodb with sharding and replicaset.

HAProxy: is configured for SSL offloading, and health checks to ensure site stays up.  #TODO: Plan to add second haproxy server with keep alive for hot-standby.

Rails App: Rails app is running Nginx, which passes to Unicorn.  Unicorn is configured for zero downtime deploys.  Eye watches unicorn processes to start app on boot and ensure Rails app stays running and restart process in case of memory leaks, etc.  Rails is using Mongoid to interact with MongoDB Cluster.

MongoDB: MongoDB is a full example which includes Sharding and Replicasets.  MongoDB is installed using 3.0.  Which has big changes including how the database locks which significantly improved performance for me.  Also install using WiredTiger which again improved performance for me.

## Supported Platforms

Ubuntu 14.04

## Attributes

## Usage

`rake` or `rake install` to install entire stack

`rake destroy` to clean up everything (except proxy, to destroy proxy uncomment line `#  lxd_proxy_destroy: true` in .kitchen.yml) before running `rake destroy`

## License and Authors

Author:: Braden Wright (braden.m.wright@gmail.com)
