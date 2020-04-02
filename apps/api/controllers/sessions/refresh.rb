module Api
  module Controllers
    module Sessions
      class Refresh
        include Api::Action

        TOKEN_LEEWAY = 24 * 3600

        def call(*)
          headers['X-Access-Token'] = current_user.generate_token
          status 200, nil
        end

      private
        def token_data
          if token = request.env['HTTP_X_ACCESS_TOKEN']
            data, _ = JWT.decode(
              token,
              ENV['HMAC_SECRET'],
              true,
              algorithm:  'HS256',
              exp_leeway: TOKEN_LEEWAY
            )
            Hanami::Utils::Hash.deep_symbolize(data)
          end
        rescue JWT::DecodeError # rubocop:disable Lint/SuppressedException
          # token expired more than a day ago or is malformed
        end
      end
    end
  end
end
