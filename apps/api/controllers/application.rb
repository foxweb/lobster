module Api
  module Controllers
    module Application
      def check_params!
        render_errors(params.errors) unless params.valid?
      end
    end
  end
end
