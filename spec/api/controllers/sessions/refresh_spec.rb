RSpec.describe Api::Controllers::Sessions::Refresh, type: :action do
  let(:action) { described_class.new }

  let(:jwt) do
    data = {
      user_id: user.id,
      exp:     exp
    }

    JWT.encode(data, ENV['HMAC_SECRET'], 'HS256')
  end

  context 'with a token that expired less than a day ago' do
    let(:exp) { Time.now.to_i - 3600 } # 1 hour ago

    it 'renders 200 OK' do
      expect(response.status).to eq(200)
    end

    it 'responds with a new JWT' do
      token = response.headers['X-Access-Token']
      expect(token).not_to be_nil
    end

    it 'generate token with valid user_id' do
      token = response.headers['X-Access-Token']

      data, _ = JWT.decode(token, ENV['HMAC_SECRET'], true, algorithm: 'HS256')
      expect(data['user_id']).to eq(user.id)
    end

    it 'generate token with valid expiration time' do
      token = response.headers['X-Access-Token']

      data, _ = JWT.decode(token, ENV['HMAC_SECRET'], true, algorithm: 'HS256')
      expiration_time = Time.now.to_i + User.jwt_ttl
      expect(data['exp']).to eq_timestamp(expiration_time)
    end
  end

  context 'with a token that expired more than a day ago' do
    let(:exp) { Time.now.to_i - 2 * 24 * 3600 } # 2 days ago

    it 'renders 401 Unauthorized' do
      expect(response.status).to eq(401)
    end
  end
end
