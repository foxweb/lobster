require 'hanami/helpers'
require_relative './controllers/rendering'

module Api
  class Application < Hanami::Application
    configure do # rubocop:disable Metrics/BlockLength
      root __dir__
      load_paths << %w[controllers serializers]
      routes 'config/routes'
      default_request_format :json
      default_response_format :json

      middleware.use Rack::Cors do
        allowed_origins = ENV.fetch('CORS_ALLOWED_ORIGIN', '').split(',')

        allow do
          origins(*allowed_origins)
          resource '*',
                   headers: %w[Content-Type X-Access-Token],
                   expose:  %w[
                     X-Access-Token
                     X-Created-Resource-Id
                     X-Existing-Resource-Id
                   ],
                   methods: %i[get post put patch delete]
        end
      end

      security.content_security_policy %(
        form-action 'self';
        frame-ancestors 'self';
        base-uri 'self';
        default-src 'none';
        script-src 'self';
        connect-src 'self';
        img-src 'self' https: data:;
        style-src 'self' 'unsafe-inline' https:;
        font-src 'self';
        object-src 'none';
        plugin-types application/pdf;
        child-src 'self';
        frame-src 'self';
        media-src 'self'
      )

      controller.prepare do
        include Api::Controllers::Rendering
        include Api::Controllers::Authorization
        before :authorize!
        include Api::Controllers::Application
        before :check_params!
      end
    end

    configure :development do
      handle_exceptions false
    end

    configure :test do
      handle_exceptions false
    end

    configure :production do
      # scheme 'https'
      # host   'example.org'
      # port   443
    end
  end
end
