require 'serverspec'

# Required by serverspec
set :backend, :exec

describe "mongod service" do

  it "is listening on port 27017" do
    expect(port(27017)).to be_listening
  end

  it "has a running service of mongod" do
    expect(service("mongod")).to be_running
  end

end

describe command("mongo --eval 'printjson(sh.status())'") do
  its(:stdout) { should match /\"_id\" : \"rs_shard1\",  \"host\" : \"rs_shard1\/db1-ubuntu-1404.lxc:27017,db2-ubuntu-1404.lxc:27017\"/ }
  its(:stdout) { should match /\"_id\" : \"rs_shard2\",  \"host\" : \"rs_shard2\/db3-ubuntu-1404.lxc:27017,db4-ubuntu-1404.lxc:27017\"/ }
  its(:stdout) { should match /Currently enabled:  yes/ }
end

