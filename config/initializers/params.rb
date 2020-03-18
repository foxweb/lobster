module Hanami
  module Action
    class Params
      def to_h
        @result.output
      end

      alias_method :to_hash, :to_h
    end
  end
end
