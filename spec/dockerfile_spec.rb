# frozen_string_literal: true

require 'docker'
require 'serverspec'

describe 'Dockerfile' do
  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ::Docker.options[:read_timeout] = 3000

    image = ::Docker::Image.build_from_dir(
      '.',
      'dockerfile' => 'Dockerfile',
      't' => 'abenevaut/docker-msys2:rspec',
      'cache-from' => 'abenevaut/docker-msys2:latest-windows10'
    )

    set :os, family: :windows
    set :backend, :docker
    set :docker_image, image.id
  end

  def bash_version
    command('bash --version').stdout
  end

  it 'installs bash' do
    expect(bash_version).to include('5.1.16')
  end
end
