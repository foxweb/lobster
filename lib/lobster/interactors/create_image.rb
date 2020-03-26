require 'hanami/interactor'

class CreateImage
  include Hanami::Interactor

  def initialize(params)
    @params = params
  end

  def call
    binding.pry
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
end
