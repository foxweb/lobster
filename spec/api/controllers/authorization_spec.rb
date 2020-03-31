RSpec.describe Api::Controllers::Authorization, type: :action do
  let(:users) { UserRepository.new }

  let(:action) do
    Api::Controllers::Images::Upload.new
  end

  context 'with a valid token' do
    it 'passes the request to the action' do
      expect(response.status).not_to eq(401)
    end
  end

  context 'with an invalid token' do
    let(:jwt) { 'not.a.token' }

    it 'renders 401 Unauthorized' do
      expect(response.status).to eq(401)
    end

    it 'renders error' do
      expect(response_body).to eq(status: 'Unauthorized')
    end
  end

  context 'with an expired token' do
    let(:jwt) do
      data = { user_id: user.id, exp: 1_500_000_000 }
      JWT.encode(data, ENV['HMAC_SECRET'], 'HS256')
    end

    it 'renders 401 Unauthorized' do
      expect(response.status).to eq(401)
    end

    it 'renders error' do
      expect(response_body).to eq(status: 'Unauthorized')
    end
  end

  context 'with a token of disabled user' do
    let(:jwt) do
      users.update(user.id, active: false)
      data = { user_id: user.id }
      JWT.encode(data, ENV['HMAC_SECRET'], 'HS256')
    end

    it 'renders 403 Forbidden' do
      expect(response.status).to eq(403)
    end

    it 'renders error' do
      expect(response_body).to eq(status: 'Forbidden')
    end
  end

  context 'with a token of an unknown user' do
    let(:jwt) do
      data = { user_id: -1 }
      JWT.encode(data, ENV['HMAC_SECRET'], 'HS256')
    end

    it 'renders 401 Unauthorized' do
      expect(response.status).to eq(401)
    end

    it 'renders error' do
      expect(response_body).to eq(status: 'Unauthorized')
    end
  end
end
