module RequestHelpers
  def self.included(klass)
    klass.class_eval do
      let(:response) do
        status, headers, body = make_request
        Rack::Response.new(body, status, headers)
      end

      let(:params) do
        {}
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
