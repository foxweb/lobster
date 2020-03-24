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

  def storage
    @storage ||= Fog::Storage.new(
      provider:               'OpenStack',
      openstack_auth_url:     'http://127.0.0.1:8080',
      openstack_api_key:      'testing',
      openstack_username:     'test:tester',
      openstack_project_name: 'project30',
      openstack_domain_id:    'default',
      openstack_cache_ttl:    60,
      persistent:             false,
      openstack_tenant:       nil,
      openstack_temp_url_key: nil
    )
  end
end
