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
      openstack_auth_url:     'http://swift:35357',
      openstack_username:     'demo',
      openstack_api_key:      'demo',
      persistent:             false,
      openstack_domain_id:    'default',
      openstack_cache_ttl:    60,
      openstack_project_name: 'test',
      openstack_temp_url_key: nil,
      provider:               'OpenStack'
    }
  end

  def storage
    @storage ||= Fog::Storage.new(connection_params)
  end
end
