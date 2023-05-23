# frozen_string_literal: true

require 'docker'
require 'serverspec'
require 'json'

describe 'Dockerfile' do
  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    # On windows we use tcp protocol rather than unix socket to communicate with docker
    ::Docker.url = ENV['DOCKER_HOST'] || 'tcp://127.0.0.1:2375'
    ::Docker.options[:read_timeout] = 1000
    ::Docker.options[:write_timeout] = 1000

    build_args = JSON.generate(
      'SERVERCORE_TAG': ENV['SERVERCORE_TAG'] || 'ltsc2022'
    )

    image = ::Docker::Image.build_from_dir(
      '.',
      {
        't' => 'abenevaut/msys2:rspec',
        'cache-from' => 'abenevaut/msys2:cache',
        'buildargs' => build_args
      }
    )

    set :os, { 'family' => 'windows' }
    set :backend, :cmd
    set :docker_image, image.id
  end

  def bash_version
    command('bash --version').stdout
  end

  it 'installs bash' do
    expect(bash_version).to include('5.2.15')
  end
end
