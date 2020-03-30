module RequestHelpers
  def self.included(klass) # rubocop:disable Metrics/MethodLength
    klass.class_eval do
      let(:response) do
        status, headers, body = make_request
        Rack::Response.new(body, status, headers)
      end

      let(:user_role) { :admin }

      let!(:user) do
        Factory.create(:user, role: user_role.to_s)
      end

      let(:params) do
        {}
      end

      after do
        UserRepository.new.clear
      end
    end
  end

private
  def make_request
    action.call(params.merge('HTTP_X_ACCESS_TOKEN' => jwt))
  end

  def response_body
    # TODO: check Content-Type header instead of inspecting response body
    Oj.load(response.body.first) if response.body.any?
  end

  def jwt
    user.generate_token
  end
end
