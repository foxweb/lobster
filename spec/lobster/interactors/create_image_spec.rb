RSpec.describe CreateImage do
  # let(:storage)     { double('Swift storage object') }
  let(:directories) { double('Swift directories object') }
  let(:directory)   { double('Swift directory object') }
  let(:files)       { double('Swift directory files object') }
  let(:local_file)  { double('Local file object') }

  let(:params) do
    { filename: 'swift_debug' }
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

  subject { described_class.new(params) }

  describe '#call' do
    context 'with valid params' do
      it 'uploads file to Swift' do
        result = subject.call
        expect(result).to be_success
      end
    end

    context 'with invalid params' do
      let(:params) do
        { filename: '4th-september.jpg' }
      end

      it 'returns errors' do
        result = subject.call
        expect(result).not_to be_success
        expect(result.errors).to include(file: ["doesn't exist"])
      end

      context 'without filename' do
        let(:params) do
          {}
        end

        it 'returns errors' do
          result = subject.call
          expect(result).not_to be_success
          expect(result.errors).to include(file: ['invalid params'])
        end
      end

      context 'with empty filename' do
        let(:params) do
          { filename: '' }
        end

        it 'returns errors' do
          result = subject.call
          expect(result).not_to be_success
          expect(result.errors).to include(file: ['invalid path'])
        end
      end
    end
  end
end
