# frozen_string_literal: true

require 'docker'
require 'serverspec'

describe 'Dockerfile.ci' do
  before(:all) do # rubocop:disable RSpec/BeforeAfterAll
    ::Docker.options[:read_timeout] = 3000

    image = ::Docker::Image.build_from_dir(
      '.',
      'dockerfile' => 'Dockerfile.ci',
      't' => 'abenevaut/yafarel-ci:rspec',
      'cache-from' => 'abenevaut/yafarel-ci:latest-php81'
    )

    set :os, family: :alpine
    set :backend, :docker
    set :docker_image, image.id
  end

  def docker_compose_version
    command('docker-compose -v').stdout
  end

  def composer_version
    command('composer -V').stdout
  end

  def bash_version
    command('bash --version').stdout
  end

  describe package('openssh-client-common') do
    it { is_expected.to be_installed }
  end

  describe package('sshpass') do
    it { is_expected.to be_installed }
  end

  describe package('python3') do
    it { is_expected.to be_installed }
  end

  describe package('py-pip') do
    it { is_expected.to be_installed }
  end

  it 'installs docker-compose' do
    expect(docker_compose_version).to include('docker-compose version 1.29.2')
  end

  describe command('php -m') do
    it 'confirm php modules' do
      expect(subject.stdout).to match(/yaf/)
    end
  end

  describe command('php -r "phpinfo();"') do
    it 'confirm phpinfo' do
      expect(subject.stdout).to match(/yaf support => enabled/)
      expect(subject.stdout).to match(/yaf.use_namespace => 1 => 1/)
      expect(subject.stdout).to match(/yaf.use_spl_autoload => 1 => 1/)
      expect(subject.stdout).to match(/yaf.environ => testing => testing/)
    end
  end

  it 'installs composer' do
    expect(composer_version).to include('2.5.5')
  end

  it 'installs bash' do
    expect(bash_version).to include('5.1.16')
  end
end
