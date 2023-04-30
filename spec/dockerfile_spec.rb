# frozen_string_literal: true

require 'docker'
require 'serverspec'

describe 'Dockerfile' do
  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    # On windows we use tcp protocol rather than unix socket to communicate with docker
    ::Docker.url = 'tcp://127.0.0.1:2375'
    ::Docker.options[:read_timeout] = 3000

    image = ::Docker::Image.build_from_dir(
      '.',
      'dockerfile' => 'Dockerfile',
      't' => 'abenevaut/msys2:rspec',
      'cache-from' => 'abenevaut/msys2:latest-windows10'
    )

    set :os, family: :windows
    set :backend, :docker
    set :docker_image, image.id
  end

  def bash_version
    command('bash --version').stdout
  end

  it 'installs bash' do
    expect(bash_version).to include('5.2.15')
  end
end
