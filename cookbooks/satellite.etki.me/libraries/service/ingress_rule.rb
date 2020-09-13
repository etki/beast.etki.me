module Etki
  module Satellite
    class Service
      class IngressRule
        # @!attribute port
        #   @return [Integer]
        attr_accessor :port
        # @!attribute path
        #   @return [String]
        attr_accessor :path
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
        # @!attribute secured Whether or not to protect using basic auth
        #   @return [Boolean]
        attr_accessor :secured

        def inspect
          Types.examine(self, :port, :addresses, :encrypted, :http_access, :https_access)
        end

        class << self
          def create(port, encrypted: false, http_access: false, https_access: true, secured: false)
            new.tap do |instance|
              instance.port = port
              instance.encrypted = encrypted
              instance.http_access = http_access
              instance.https_access = https_access
              instance.secured = secured
            end
          end

          def normalize(value)
            return value if value.is_a?(IngressRule) || value.nil?

            return create(value) if value.is_a?(Integer)

            if value.is_a?(Hash)
              port = Hashes.shift(value, :port)
              return create(port, value)
            end

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
