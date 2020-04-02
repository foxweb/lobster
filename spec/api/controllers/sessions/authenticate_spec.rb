RSpec.describe Api::Controllers::Sessions::Authenticate, type: :action do
  let(:action) { described_class.new }
  let(:users)  { UserRepository.new }

  let(:jwt) { nil }

  context 'with existing email & correct password' do
    let(:params) do
      {
        email:    user.email,
        password: 'secret'
      }
    end

    it 'renders 200 OK' do
      expect(response.status).to eq(200)
    end

    it 'responds with a valid JWT' do
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

    context 'with disabled user' do
      before do
        users.update(user.id, active: false)
      end

      it 'renders 403 Forbidden' do
        expect(response.status).to eq(403)
      end
    end
  end

  context 'with existing email and wrong password' do
    let(:params) do
      {
        email:    'user@example.com',
        password: 'wrong'
      }
    end

    it 'renders 422 Unprocessable Entity' do
      expect(response.status).to eq(422)
    end

    it 'renders errors' do
      expect(response_body).to eq(password: ['is incorrect'])
    end
  end

  context 'with non-existing email' do
    let(:params) do
      {
        email:    'unknown@example.com',
        password: 'password'
      }
    end

    it 'renders 422 Unprocessable Entity' do
      expect(response.status).to eq(422)
    end

    it 'renders errors' do
      expect(response_body).to eq(password: ['is incorrect'])
    end
  end

  context 'with invalid params' do
    let(:params) do
      { email: 123 }
    end

    it 'renders 422 Unprocessable Entity' do
      expect(response.status).to eq(422)
    end

    it 'renders errors' do
      expect(response_body).to eq(
        email:    ['must be a string'],
        password: ['is missing']
      )
    end
  end
end
