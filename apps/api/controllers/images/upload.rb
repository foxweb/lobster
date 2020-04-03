module Api
  module Controllers
    module Images
      class Upload
        include Api::Action

        requires_permission_to :upload, :images

        params do
          required(:filename)     { filled? & str? }
          required(:content_type) { filled? & str? }
          required(:temp_path)    { filled? & str? }
        end

        def call(*)
          result = CreateAttachment.new(image_data).call

          if result.success?
            render_raw(201, result.uploaded_file)
          else
            render_errors(result.errors.inject(:merge))
          end
        end

      private
        def image_data
          params.to_h.merge(uploaded_by: current_user.id)
        end
      end
    end
  end
end
