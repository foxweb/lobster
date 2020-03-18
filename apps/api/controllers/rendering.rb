module Api
  module Controllers
    module Rendering
    private
      def render_ok(data)
        render_raw 200, data.as_json
      end

      def render_created(resource)
        raise ArgumentError if resource.id.nil?

        headers['X-Created-Resource-Id'] = resource.id.to_s
        status 201, nil
      end

      def render_no_content
        halt 204, nil
      end

      def render_unauthorized
        render_raw 401, status: 'Unauthorized'
      end

      def render_forbidden
        render_raw 403, status: 'Forbidden'
      end

      def render_not_found
        render_raw 404, status: 'Not Found'
      end

      def render_conflict(resource)
        raise ArgumentError if resource.id.nil?

        headers['X-Existing-Resource-Id'] = resource.id.to_s
        status 409, nil
      end

      def render_errors(errors)
        render_raw 422, errors.to_h
      end

      def render_raw(status, body)
        halt(status, Oj.dump(body))
      end

      def serializer
        namespaces = self.class.name.split('::')
        namespaces[1] = 'Serializers'

        Hanami::Utils::Class.load(namespaces.join('::'))
      end
    end
  end
end
