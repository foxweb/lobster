RSpec.describe CreateImage do
  subject(:create_image) { described_class.new(params) }

  let(:directories) { instance_double('Swift directories object') }
  let(:directory)   { instance_double('Swift directory object') }
  let(:files)       { instance_double('Swift directory files object') }
  let(:local_file)  { instance_double('Local file object') }

  let(:params) do
    { temp_path: './spec/fixtures/image.jpg' }
  end

  let(:storage) do
    Fog.mock!
    Fog::Storage.new(
      openstack_auth_url:     ENV['OPENSTACK_AUTH_URL'],
      openstack_username:     ENV['OPENSTACK_USERNAME'],
      openstack_api_key:      ENV['OPENSTACK_API_KEY'],
      persistent:             ENV['OPENSTACK_PERSISTENT'],
      openstack_domain_id:    ENV['OPENSTACK_DOMAIN_ID'],
      openstack_cache_ttl:    ENV['OPENSTACK_CACHE_TTL'].to_i,
      openstack_project_name: ENV['OPENSTACK_PROJECT_NAME'],
      openstack_temp_url_key: ENV['OPENSTACK_TEMP_URL_KEY'],
      provider:               ENV['OPENSTACK_PROVIDER']
    )
  end

  describe '#call' do
    context 'with valid params' do
      it 'uploads file to Swift' do
        result = create_image.call
        expect(result).to be_success
      end
    end

    context 'with invalid params' do
      let(:params) do
        { temp_path: '4th-september.jpg' }
      end

      it 'returns errors' do
        result = create_image.call
        expect(result.errors).to include(file: ["doesn't exist"])
      end

      it 'not to be success' do
        result = create_image.call
        expect(result).not_to be_success
      end
    end

    context 'without filename' do
      let(:params) do
        {}
      end

      it 'returns errors' do
        result = create_image.call
        expect(result.errors).to include(file: ['invalid params'])
      end

      it 'not to be success' do
        result = create_image.call
        expect(result).not_to be_success
      end
    end

    context 'with empty filename' do
      let(:params) do
        { temp_path: '' }
      end

      it 'returns errors' do
        result = create_image.call
        expect(result.errors).to include(file: ['invalid path'])
      end

      it 'not to be success' do
        result = create_image.call
        expect(result).not_to be_success
      end
    end
  end
end
