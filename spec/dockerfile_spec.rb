# frozen_string_literal: true

require 'docker'
require 'serverspec'

describe 'Dockerfile' do
  def default_docker_host
    if ENV["DOCKER_HOST"]
      ENV["DOCKER_HOST"]
    elsif File.exist?("/var/run/docker.sock")
      "unix:///var/run/docker.sock"
    # TODO: Docker for Windows also operates over a named pipe at
    # //./pipe/docker_engine that can be used if named pipe support is
    # added to the docker-api gem.
    else
      "tcp://127.0.0.1:2375"
    end
  end

  before(:all) do # rubocop:disable RSpec/BeforeAfterAll

    ::Docker.url = default_docker_host


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
