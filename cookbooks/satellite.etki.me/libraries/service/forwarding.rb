require_relative 'interface'

module Etki
  module Satellite
    class Service
      class Forwarding
        # @!attribute source
        #   @return [Interface]
        attr_accessor :source

        # @!attribute target
        #   @return [Interface]
        attr_accessor :target

        def inspect
          Types.examine(self, :source, :target)
        end

        class << self
          def create(source, target)
            Forwarding.new.tap do |instance|
              instance.source = Interface.normalize(source)
              instance.target = Interface.normalize(target) || instance.source
            end
          end

          def normalize(value)
            return value if value.is_a?(Forwarding) || value.nil?

            value = { port: value } if value.is_a?(Integer)

            if value.is_a?(Hash)
              has_nested_key = Hashes.key?(value, :port)
              has_top_level_key = Hashes.key?(value, :source)

              value = { source: value } if has_nested_key && !has_top_level_key

              return Forwarding.create(*Hashes.get(value, :source, :target))
            end

            raise "Can't normalize value of #{value.class}"
          end

          def normalize_many(values)
            values.map { |value| normalize(value) }
          end
        end
      end
    end
  end
end
