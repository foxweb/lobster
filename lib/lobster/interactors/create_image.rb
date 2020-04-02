require 'hanami/interactor'

class CreateImage
  include Hanami::Interactor

  DIRNAME = 'attachments'.freeze

  expose :uploaded_file

  def initialize(params)
    @params = params
  end

  def call
    check_params
    check_filename
    error!(file: ["doesn't exist"]) unless local_file.exist?
    @uploaded_file = directory.files.create(payload)
  rescue Excon::Error
    error!(file: ['is not uploaded'])
  end

private
  attr_reader :params

  def connection_params
    {
      openstack_auth_url:     ENV['OPENSTACK_AUTH_URL'],
      openstack_username:     ENV['OPENSTACK_USERNAME'],
      openstack_api_key:      ENV['OPENSTACK_API_KEY'],
      persistent:             ENV['OPENSTACK_PERSISTENT'],
      openstack_domain_id:    ENV['OPENSTACK_DOMAIN_ID'],
      openstack_cache_ttl:    ENV['OPENSTACK_CACHE_TTL'].to_i,
      openstack_project_name: ENV['OPENSTACK_PROJECT_NAME'],
      openstack_temp_url_key: ENV['OPENSTACK_TEMP_URL_KEY'],
      provider:               ENV['OPENSTACK_PROVIDER']
    }
  end

  def storage
    @storage ||= Fog::Storage.new(connection_params)
  end

  def directory
    storage.directories.create(key: DIRNAME)
  end

  def local_file
    Hanami.root.join(params[:temp_path])
  end

  def payload
    {
      key:  params[:temp_path],
      body: File.open(local_file)
    }
  end

  def check_filename
    error!(file: ['invalid path']) if params[:temp_path].empty?
  end

  def check_params
    error!(file: ['invalid params']) if params[:temp_path].nil?
  end
end
