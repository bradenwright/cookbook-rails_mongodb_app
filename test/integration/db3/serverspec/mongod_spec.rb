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

describe command("mongo --eval 'printjson(rs.status())'") do
  its(:stdout) { should match /\"name\" : \"db3-ubuntu-1404.lxc:27017\",\n\t\t\t\"health\" : 1,\n/ }
  its(:stdout) { should match /\"name\" : \"db4-ubuntu-1404.lxc:27017\",\n\t\t\t\"health\" : 1,\n/ }
end

