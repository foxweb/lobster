require 'dry/container'

module Lobster
  class << self
    def container
      @container ||= Dry::Container.new
    end

    DbSchema.current_schema.enums.each do |enum|
      define_method(Hanami::Utils::String.pluralize(enum.name)) do
        DbSchema.current_schema.enum(enum.name).values.map(&:to_s)
      end
    end
  end

  container.register(:rabbit, memoize: true) do
    Rabbit.new
  end
end
