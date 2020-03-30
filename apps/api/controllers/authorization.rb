module Api
  module Controllers
    module Authorization
      module ClassMethods
        attr_reader :acl_action, :acl_subject

        def requires_permission_to(acl_action, acl_subject)
          @acl_action = acl_action
          @acl_subject = acl_subject
        end

        def allows_guest
          @allows_guest = true
        end

        def allows_guest?
          !@allows_guest.nil?
        end
      end

      class << self
        def included(klass)
          klass.extend(ClassMethods)
        end
      end

      def authorize!
        return if self.class.allows_guest?

        render_unauthorized if current_user.nil?
        render_forbidden unless current_user.active?
        render_forbidden unless current_user_has_permission?
      end

      def current_user_has_permission?
        self.class.acl_action.nil? ||
          self.class.acl_subject.nil? ||
          current_user.can?(self.class.acl_action, self.class.acl_subject)
      end

      def current_user
        unless token_data.nil?
          @current_user ||= UserRepository.new.find(token_data.fetch(:user_id))
        end
      end

    private
      def token_data
        if token = request.env['HTTP_X_ACCESS_TOKEN']
          data, _ = JWT.decode(
            token,
            ENV['HMAC_SECRET'],
            true,
            algorithm: 'HS256'
          )
          Hanami::Utils::Hash.deep_symbolize(data)
        end
      rescue JWT::DecodeError # rubocop:disable Lint/SuppressedException
        # token is expired or malformed
      end
    end
  end
end
