require_relative './deletable'

class AttachmentRepository < Hanami::Repository
  include Deletable
end
