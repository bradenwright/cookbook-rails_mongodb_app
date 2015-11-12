require 'spec_helper'

describe 'rails_mongodb_app::_database' do
  let(:chef_run) {
#    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '14.04')
    ChefSpec::ServerRunner.new(:platform => 'ubuntu', :version => '14.04')

  }

  it 'includes recipe rails_mongodb_app' do
    chef_run.converge described_recipe
    expect(chef_run).to include_recipe('rails_mongodb_app')
  end

end
