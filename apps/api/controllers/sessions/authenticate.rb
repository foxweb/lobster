module Api
  module Controllers
    module Sessions
      class Authenticate
        include Api::Action

        allows_guest

        params do
          required(:email)    { filled? & str? }
          required(:password) { filled? & str? }
        end

        def call(*)
          if (user = find_user) && user.password_correct?(params[:password])
            render_forbidden unless user.active?

            headers['X-Access-Token'] = user.generate_token
            status 200, nil
          else
            render_errors(password: ['is incorrect'])
          end
        end

      private
        def find_user
          UserRepository.new.find_by_email(params[:email])
        end
      end
    end
  end
end
