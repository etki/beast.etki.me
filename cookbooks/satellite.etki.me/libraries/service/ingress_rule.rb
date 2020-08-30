module Etki
  module Satellite
    class Service
      class IngressRule
        # @!attribute port
        #   @return [Integer]
        attr_accessor :port
        # @!attribute addresses
        #   @return [Array<String>]
        attr_accessor :addresses
        # @!attribute encrypted
        #   @return [Boolean] Whether or not backend exposed using HTTPS
        attr_accessor :encrypted
        # @!attribute http_access
        #   @return [Boolean]
        attr_accessor :http_access
        # @!attribute https_access
        #   @return [Boolean]
        attr_accessor :https_access

        def inspect
          Types.examine(self, :port, :addresses, :encrypted, :http_access, :https_access)
        end

        class << self
          def create(port, encrypted: false, http_access: false , https_access: true)
            new.tap do |instance|
              instance.port = port
              instance.encrypted = encrypted
              instance.http_access = http_access
              instance.https_access = https_access
            end
          end

          def normalize(value)
            return value if value.is_a?(IngressRule) || value.nil?

            return create(value) if value.is_a?(Integer)

            return create(Hashes.fetch(value, :port), value) if value.is_a?(Hash)

            raise "Can't use value #{value.inspect} (#{value.class}) for normalization"
          end

          def normalize_many(values)
            values.map { |value| normalize(value) }
          end
        end
      end
    end
  end
end
