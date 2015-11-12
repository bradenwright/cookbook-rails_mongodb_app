require 'spec_helper'

describe 'rails_mongodb_app::_base' do
  let(:chef_run) {
    ChefSpec::SoloRunner.new(:platform => 'ubuntu', :version => '14.04')
#    ChefSpec::ServerRunner.new(:platform => 'ubuntu', :version => '14.04')

  }

  it 'includes recipe apt' do
    chef_run.converge described_recipe
    expect(chef_run).to include_recipe('apt')
  end

  it 'installs vim package' do
    chef_run.converge described_recipe
    expect(chef_run).to install_package('vim')
  end

  it 'includes recipe build-essential' do
    chef_run.converge described_recipe
    expect(chef_run).to include_recipe('build-essential')
  end

  it 'installs build-essential package' do
    chef_run.converge described_recipe
    expect(chef_run).to install_package('build-essential')
  end
end
