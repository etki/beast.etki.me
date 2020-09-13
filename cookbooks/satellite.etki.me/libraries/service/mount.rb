require 'pathname'

module Etki
  module Satellite
    class Service
      class Mount
        # @!attribute source
        #   @return [Pathname]
        attr_accessor :source

        # @!attribute target
        #   @return [Pathname]
        attr_accessor :target

        # @!attribute writable
        #   @return [Boolean]
        attr_accessor :writable

        def inspect
          ::Etki::Satellite::Types.examine(self, :source, :target, :writable)
        end

        class << self
          def create(source, target, writable = false)
            Mount.new.tap do |instance|
              instance.source = Pathname.new(source)
              instance.target = Pathname.new(target)
              instance.writable = writable
            end
          end

          def normalize(value)
            return value if value.is_a?(Mount) || value.nil?

            return create(value.to_s, value.to_s) if value.is_a?(String) || value.is_a?(Symbol)

            return create(*Hashes.get(value, :source, :target, :writable)) if value.is_a?(Hash)

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
